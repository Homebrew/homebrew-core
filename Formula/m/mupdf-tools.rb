class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.28.0-source.tar.gz"
  sha256 "21c7f064903154f1c3a7458bee81f130fc36f9b5147ea13328f9980e02d2dea2"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b63d3a04421ef4c8ec74c97e823350fb1ca1e1eda0b96b0f8d26fb1295837406"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "616c5074c42bbb76e87f1fd8fdbc0eee9d41c7c8217fa523e60cd46531190765"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ac8271930d617ea763224c13f7eb686dba99e59e453abcc3179f71e4a8daaa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3822368ccd1d43bf7fb5ac01c3575a88a6e9a334de7ffd24d729029fb14df96c"
    sha256 cellar: :any,                 arm64_linux:   "86c8ff53a25beb28246d99af692e1f2cde92816405f202802118c4e4ddd01c14"
    sha256 cellar: :any,                 x86_64_linux:  "53954de2905807fec1d485b4d9655b0db9723ad0c8a105465b3090dc7467217c"
  end

  conflicts_with "mupdf", because: "mupdf and mupdf-tools install the same binaries"

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "HAVE_GLUT=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
