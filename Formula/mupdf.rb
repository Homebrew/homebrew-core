class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.19.1-source.tar.xz"
  sha256 "b5eac663fe74f33c430eda342f655cf41fa73d71610f0884768a856a82e3803e"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2d4d098f0541d95b2d3540af421bd8e835ac1a1192acb98312dc78b4e921e354"
    sha256 cellar: :any,                 arm64_big_sur:  "7f544e397266ed96ccc842e534d083b50b44b524b8fca55848c671942da2af45"
    sha256 cellar: :any,                 monterey:       "ff857e9ab23091ac27da6c85f318c3263fa2efd9051f4cfe2013b8b7f44c45be"
    sha256 cellar: :any,                 big_sur:        "d7ba31afbad3e307b89f839dc32e3315951041c5da2d0c97b773121638b62f58"
    sha256 cellar: :any,                 catalina:       "a05964e33ab125e327e0365a1de22588dadca8a9e88d39072f64ec16b13cde31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0135bc4dfe4aa29f4a680829b1b7a18c0d66cde39856cd1bacdd8d1bac2be67"
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
           "verbose=yes",
           "CC=#{ENV.cc}",
           "SYS_GLUT_CFLAGS=#{glut_cflags}",
           "SYS_GLUT_LIBS=#{glut_libs}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
