class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"

  stable do
    url "https://github.com/nickg/nvc/releases/download/r1.0.0/nvc-1.0.0.tar.gz"
    sha256 "a60478636268a7d1cad2d1c90e775cfd938199dba6b9c407badbef32753dc30f"

    # Fixes nickg/nvc#265
    # nvc needs external vhdl libraries at build
    # PR adds https and checksums to the download script - fetch-ieee.sh
    patch do
      url "https://github.com/nickg/nvc/pull/296.patch"
      sha256 "68cc9d23c286945a63464f9aa71d25d1e1b140e4652845c837cae3babbc45ab6"
    end
  end
  bottle do
    sha256 "63d766663a4aed43ba91d853abc4f6e23423c8fbcc07e6fffe1d558e886bdd57" => :sierra
    sha256 "e21c764dae84a026ca2c69e6040303bb501022e525d49e9130331d5c95b02ca9" => :el_capitan
    sha256 "5a5fb69e028a07bcde7c1010ea67ee51c5e8f72be81982d50f5f17f3595dd003" => :yosemite
  end

  head do
    url "https://github.com/nickg/nvc.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "llvm" => :build
  depends_on "check" => :build

  resource "vim-hdl-examples" do
    url "https://github.com/suoto/vim-hdl-examples.git",
    :revision => "232d28a9279bc80d2797afef212749434a78be6a"
  end

  def install
    args = %W[
      --with-llvm=#{Formula["llvm"].opt_bin}/llvm-config
      --prefix=#{prefix}
    ]

    system "./autogen.sh" unless build.stable?
    system "./tools/fetch-ieee.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    resource("vim-hdl-examples").stage testpath
    system "#{bin}/nvc", "-a", "#{testpath}/basic_library/very_common_pkg.vhd"
  end
end
