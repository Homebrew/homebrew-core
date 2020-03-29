class Minizip < Formula
  desc "C library for zip/unzip via zLib"
  homepage "https://www.winimage.com/zLibDll/minizip.html"
  url "https://zlib.net/zlib-1.2.11.tar.gz"
  sha256 "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"

  bottle do
    cellar :any
    rebuild 2
    sha256 "80d48e6cf3f3c64f618f1cb7487c6ac9a7259ba46c536dac286ef6bdffaacd8c" => :catalina
    sha256 "503832d6da09e7f16b7036ee1cf3055c25ba3602d3ea9815a9800d1840fb69ea" => :mojave
    sha256 "9fa636770888ef4e9aaa3c1bbf2d3c18fb0e4c393305c2ecf265ca79ecee6e71" => :high_sierra
    sha256 "83e4b5b1b52ff484a0ba73637e0961ed3d41ecba4ee3c3cfe667d13ef7e51ad7" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "zlib"

  conflicts_with "minizip2",
    :because => "both install a `libminizip.a` library"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"

    cd "contrib/minizip" do
      # edits to statically link to libz.a
      inreplace "Makefile.am" do |s|
        s.sub! "-L$(zlib_top_builddir)", "$(zlib_top_builddir)/libz.a"
        s.sub! "-version-info 1:0:0 -lz", "-version-info 1:0:0"
        s.sub! "libminizip.la -lz", "libminizip.la"
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
