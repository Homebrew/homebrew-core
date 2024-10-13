class Minizip < Formula
  desc "C library for zip/unzip via zLib"
  homepage "https://www.winimage.com/zLibDll/minizip.html"
  url "https://zlib.net/zlib-1.3.1.tar.gz"
  mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.3.1/zlib-1.3.1.tar.gz"
  sha256 "9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23"
  license "Zlib"

  livecheck do
    formula "zlib"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "3641776397e76574fcfe89466a78fd4dfedf9318a3c773fbfaffb0f0ec696547"
    sha256 cellar: :any,                 arm64_sonoma:   "3bc53490be71be5fcf8c018ba2db9b061dbedf50a12c6f6fabcc9f4df003cfc5"
    sha256 cellar: :any,                 arm64_ventura:  "d60c0678b1ac599448e1dd216aa3e44a9b9f11c00bfd7271eaa5c9e4296a3ad4"
    sha256 cellar: :any,                 arm64_monterey: "437e23f93e1777d4b4f4d849bc6026361ba46591ba8081d8ab289a3d6dba45c3"
    sha256 cellar: :any,                 sonoma:         "927f46afb50e1cef0f6c7024cea807025835379984c786d8a17ceef071a2367f"
    sha256 cellar: :any,                 ventura:        "17ea4d0486f352f08d526f54149cc61351456325a2f49cd2a5e85f43a5c8180a"
    sha256 cellar: :any,                 monterey:       "fda3b687c8bf4b06f369ec2c43e2fba4fa08d0a8d80ca46b605cf79e18ea0c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "031048178895f72541584dabaa7b5606b9fbbbdeaf4dfcc7aeccfe0a05fcf4ee"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "zlib"

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
