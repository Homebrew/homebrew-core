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
    sha256 cellar: :any,                 arm64_monterey: "ff18fe7d07a68f17366a40f39a05604049a88ac4ce58a63820ac57fa6f8af476"
    sha256 cellar: :any,                 arm64_big_sur:  "68d0ae9dc6ec0efa701f68af2663fc85da36e33a957743c5b01bae3118a04078"
    sha256 cellar: :any,                 monterey:       "1d2ce07558bfa685effb10a2ab00683427f60f3d286f99488c5b42017b5f04ff"
    sha256 cellar: :any,                 big_sur:        "98c64a1187ce693d07d4cfcb0abee35b88157b5491132fb495097641f7803ed8"
    sha256 cellar: :any,                 catalina:       "ecb193a80dd68f0b38401183294bf282c5046814fd4692afdfb37989df702755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ac31c56f146beebcebcbee8d51bd680f202e5b7a29588abeca3c0cdee6dc748"
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
