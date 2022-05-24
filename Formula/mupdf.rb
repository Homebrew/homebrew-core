class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.19.1-source.tar.xz"
  sha256 "b5eac663fe74f33c430eda342f655cf41fa73d71610f0884768a856a82e3803e"
  license "AGPL-3.0-or-later"
  revision 1
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "601fd11aca193d1d6edd066aaf0cbe48d6742fcb68e37fbd60ce7a4082ba1647"
    sha256 cellar: :any,                 arm64_big_sur:  "257b6bd26ad138a33f8939199c8cacd9165e5278fd77014ff11e332894d0f5f2"
    sha256 cellar: :any,                 monterey:       "f569055dc473c50bcf8d330f348181ad6477d5916ae104fe50705963ef631ba3"
    sha256 cellar: :any,                 big_sur:        "9e3bf31fa589e7c1628479358ac2d7946b4bc34ba56d9b726eb7b49419142bc6"
    sha256 cellar: :any,                 catalina:       "f52a2d6b6fdbdf1b296f1792f644f8c18dd85726276de2eab0e9e6ff45858e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c5236cd7f1279fa9427ed73ff6007d8f3d3ea2af31068e80b6e4de3bc06b1ed"
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
