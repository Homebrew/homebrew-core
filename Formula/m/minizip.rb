class Minizip < Formula
  desc "C library for zip/unzip via zLib"
  homepage "https://www.winimage.com/zLibDll/minizip.html"
  url "https://zlib.net/zlib-1.3.tar.gz"
  mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.3/zlib-1.3.tar.gz"
  sha256 "ff0ba4c292013dbc27530b3a81e1f9a813cd39de01ca5e0f8bf355702efa593e"
  license "Zlib"

  livecheck do
    formula "zlib"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f3d9b263ad61ca60aae384f6bded9d90c9422cfb33a8327860d5032d448ddde8"
    sha256 cellar: :any,                 arm64_ventura:  "70437e5a4551db22f4207037b2d1aa10b2dd95b08e02e0c39147bb2f30d548d3"
    sha256 cellar: :any,                 arm64_monterey: "f08f116c85142b0110ad79e64a6897051d821c2c1c1a3c828b2c7b65d82e8036"
    sha256 cellar: :any,                 arm64_big_sur:  "2af66a8d186a7795653328eaeeadf8d87c30fbc64a3b5bd2b90c7ddd982ca29f"
    sha256 cellar: :any,                 sonoma:         "eb3f0bb7490dd1a6c322bcbd24a8540c0202bd025d044a48af621954efd04e03"
    sha256 cellar: :any,                 ventura:        "f62192c0603d491535090d3344b311d8d5bb5054b47718cf7cfee019c0f36097"
    sha256 cellar: :any,                 monterey:       "fe3e260a1c545bfc24acfeb4c07ea05630e1c2e1f27f9efdc4ac3780a85e84a0"
    sha256 cellar: :any,                 big_sur:        "61728c27b1125d23959cc3bde477a58f3c83ab7e7e7645513e8a7492ff7c6d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6bd092c36f2e3b911264586e02a5bea6bb8bf9f0e380764971842354449946c"
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
