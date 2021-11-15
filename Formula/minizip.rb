class Minizip < Formula
  desc "C library for zip/unzip via zLib"
  homepage "https://www.winimage.com/zLibDll/minizip.html"
  url "https://zlib.net/zlib-1.2.11.tar.gz"
  sha256 "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"
  license "Zlib"

  livecheck do
    formula "zlib"
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "3a9a867bd73462f129c1516ef669dcc9b2e3655f28102c55b165cf2b424ffd34"
    sha256 cellar: :any,                 arm64_big_sur:  "fc8a34713482035711b688e21d0998387edd108bf7c22f3fdb38e14f7860646f"
    sha256 cellar: :any,                 monterey:       "1c1b7f79e78ac58ace1b7bae4037220c4a046b051a824c087f35ae932db3b1db"
    sha256 cellar: :any,                 big_sur:        "ac7c1bda7e98ef6ce3530f3de75e5eee8bbe95330614ac9646761c281f37d0a0"
    sha256 cellar: :any,                 catalina:       "80d48e6cf3f3c64f618f1cb7487c6ac9a7259ba46c536dac286ef6bdffaacd8c"
    sha256 cellar: :any,                 mojave:         "503832d6da09e7f16b7036ee1cf3055c25ba3602d3ea9815a9800d1840fb69ea"
    sha256 cellar: :any,                 high_sierra:    "9fa636770888ef4e9aaa3c1bbf2d3c18fb0e4c393305c2ecf265ca79ecee6e71"
    sha256 cellar: :any,                 sierra:         "83e4b5b1b52ff484a0ba73637e0961ed3d41ecba4ee3c3cfe667d13ef7e51ad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faa8b87e09ee6af763b3be6fa2e36c10d12f04c14d76d183249262aa7ab9fa30"
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
