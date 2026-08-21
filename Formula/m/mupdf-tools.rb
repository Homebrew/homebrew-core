class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.28.2-source.tar.gz"
  sha256 "44075a84e329db55b9bef5f342a70fd26d69e48ad1d33cb89d9664581c641156"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69a127f018a1b13c41d186f5653e0fa2dc87f306d2bda9532d0f9636659cb77d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "618b71ee0afb6f580c63269c5173e6bef7e080cc2fcfa1def95092c986ea388c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61d4ec722053dccb75ae71561bd5cce6d107a11bcdf2954f059abcf60f5978bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "bba5e444e832028823db5f4df2a4dfecc5de5e820da8a5fcb2d99145fe6a1b07"
    sha256 cellar: :any,                 arm64_linux:   "110e2fc500ce56ea960b3dd3323ce322dbf82de9d867d187b05438141af32328"
    sha256 cellar: :any,                 x86_64_linux:  "3c92a26441c0b7bad81ccd6e7f62f2d9c1ccfeb00c7c38f5ff448228c6f8f6e0"
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
