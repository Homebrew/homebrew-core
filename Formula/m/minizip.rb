class Minizip < Formula
  desc "C library for zip/unzip via zLib"
  homepage "https://www.winimage.com/zLibDll/minizip.html"
  url "https://zlib.net/zlib-1.2.13.tar.gz"
  mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.2.13/zlib-1.2.13.tar.gz"
  sha256 "b3a24de97a8fdbc835b9833169501030b8977031bcb54b3b3ac13740f846ab30"
  license "Zlib"

  livecheck do
    formula "zlib"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f04d79cbe3e1d6c2ceae2cbbee835c914b9ada6c536da659aa947b34109e4ec8"
    sha256 cellar: :any,                 arm64_monterey: "24bd919aa1dde395f929d897743f9235fd6023e017e983c0169a0918987a40ba"
    sha256 cellar: :any,                 arm64_big_sur:  "a604caa335ee965ce1b29e70ba1cd5db183fb9cfd7f70c9141644a2013423289"
    sha256 cellar: :any,                 ventura:        "8d6734507310e18a70548bd96afd469b38da2a34ea6bcec9d46c6ac94f6afd30"
    sha256 cellar: :any,                 monterey:       "3bca4aaed9dba859600379d30b3f2aaa2cfd06a406208f163366d14c8bb6cb53"
    sha256 cellar: :any,                 big_sur:        "80e4849ce70b1ac5be25d1886947651629e9ac82ec7a5ec47dd28ee0a3499381"
    sha256 cellar: :any,                 catalina:       "a0b93c2d3e4beef15171d95e1fe37b3ca9d7764a101dae2f9a6bacc972e047e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1f2d6483bfeb86f7e3266a3e07b96593f4bb383fc9297e86583735c51efb86b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "zlib"

  conflicts_with "minizip-ng",
    because: "both install a `libminizip.a` library"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"

    cd "contrib/minizip" do
      if OS.mac?
        # edits to statically link to libz.a
        inreplace "Makefile.am" do |s|
          s.sub! "-L$(zlib_top_builddir)", "$(zlib_top_builddir)/libz.a"
          s.sub! "-version-info 1:0:0 -lz", "-version-info 1:0:0"
          s.sub! "libminizip.la -lz", "libminizip.la"
        end
      end
      system "autoreconf", "-fi"
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      Minizip headers installed in 'minizip' subdirectory, since they conflict
      with the venerable 'unzip' library.
    EOS
  end
end
