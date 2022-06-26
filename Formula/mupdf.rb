class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.20.0-source.tar.lz"
  sha256 "68dbb1cf5e31603380ce3f1c7f6c431ad442fa735d048700f50ab4de4c3b0f82"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "03b44ccd0487381a58a07de71e21e1918f2fc3190e1d722279524e52d6c6048d"
    sha256 cellar: :any,                 arm64_big_sur:  "4dfdeb86efe9bb8916894a9f205303c9a3f30f9196d4581b58210ce911a15901"
    sha256 cellar: :any,                 monterey:       "98b7f2424ffa5f77a81746b1d7de923ca60dcd646f84b79f56609811e6e0ad1b"
    sha256 cellar: :any,                 big_sur:        "5e4fde38177603b4290d8ce7fb87af8445e98e902b59186bc96d5bfa20a6e8ca"
    sha256 cellar: :any,                 catalina:       "2a78967b68a4f3ed3312388503fa26c2604ac83201a76fb7cb6fcc9284833228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce34ee7f29f260e04c6b135d7d1d139d4f395cb68aa5ea47016770911688706d"
  end

  depends_on "pkg-config" => :build
  depends_on "freeglut"
  depends_on "mesa"

  conflicts_with "mupdf-tools",
    because: "mupdf and mupdf-tools install the same binaries"

  def install
    glut_cflags = `pkg-config --cflags glut gl`.chomp
    glut_libs = `pkg-config --libs glut gl`.chomp
    system "make", "install",
           "build=release",
           "shared=yes",
           "verbose=yes",
           "CC=#{ENV.cc}",
           "SYS_GLUT_CFLAGS=#{glut_cflags}",
           "SYS_GLUT_LIBS=#{glut_libs}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"

    lib.install_symlink lib/shared_library("libmupdf") => shared_library("libmupdf-third")
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
