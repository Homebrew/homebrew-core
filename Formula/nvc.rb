class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.2.0/nvc-1.2.tar.gz"
  version "1.2.0"
  sha256 "9cd31758b0b5cc924bda1ef87d84a78deaa2376f0664c3c87b7045e669d02b52"

  bottle do
    sha256 "71345ead6ade1e57062c995c531363c7ffa8e9b18f64b5d612e2533220482349" => :sierra
    sha256 "25f22ee4d512e23c5c1beb0f997b57cfd991860415975984321adbfbdf8b285e" => :el_capitan
    sha256 "75bf156e1e3ce25506c6298204e3f9257834e5e3f4bbfb8cda72593998d9168f" => :yosemite
  end

  head do
    url "https://github.com/nickg/nvc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "llvm" => :build
  depends_on "check" => :build

  resource "vim-hdl-examples" do
    url "https://github.com/suoto/vim-hdl-examples.git",
        :revision => "c112c17f098f13719784df90c277683051b61d05"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./tools/fetch-ieee.sh"
    system "./configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    resource("vim-hdl-examples").stage testpath
    system "#{bin}/nvc", "-a", "#{testpath}/basic_library/very_common_pkg.vhd"
  end
end
