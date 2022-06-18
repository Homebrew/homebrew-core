class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.20.0-source.tar.lz"
  sha256 "68dbb1cf5e31603380ce3f1c7f6c431ad442fa735d048700f50ab4de4c3b0f82"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86ecef46f23f8939c14b955a7e11cb2e96698f178bfc32467e55f4e99e473267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "118715fa212034b534eec4e145577e81968b49959da8e6b817a41724fc343f96"
    sha256 cellar: :any_skip_relocation, monterey:       "b934ff3f384b9a4e28e0cde1c87112b6b8908b7c2c19c30dee6cdc289e7bce3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbbe6aaecc0e80090c021f92606295dac1f7258f958fbed685eb4c75492b5fb0"
    sha256 cellar: :any_skip_relocation, catalina:       "21d3b0129446781d43f07b07af39c2bfa566c5301b3d408d647779d2c8300895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09b118451dcf86336226085392df196a2545c66e02d508fdbb75a102d56da886"
  end

  conflicts_with "mupdf",
    because: "mupdf and mupdf-tools install the same binaries"

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
