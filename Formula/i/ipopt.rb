class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://github.com/coin-or/Ipopt/archive/refs/tags/releases/3.14.15.tar.gz"
  sha256 "98c9bf2a7eb3c82f2a68d59dbe5cd87370539ade144b0553370730ccd98cf143"
  license "EPL-2.0"
  head "https://github.com/coin-or/Ipopt.git", branch: "stable/3.14"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7bcaf3bddedad88d8ea1b08541006626197ad9d9e58da7bb0947d79dd9712c0d"
    sha256 cellar: :any,                 arm64_ventura:  "f09e8de3c2fc540b271812c79a0224b790eb1d5f702dce1224ff3c4d5e74a2fd"
    sha256 cellar: :any,                 arm64_monterey: "06d9c2b1fbfb0020fee81dc8df8bdc9db07177b7509140d38f5caadc5b20990c"
    sha256 cellar: :any,                 sonoma:         "03f583292471d22e6816f9daa646e8cab46f77a4d43fbc1a00fbb42d100ebbf2"
    sha256 cellar: :any,                 ventura:        "f03aa251c8f99a539ea086db10e086ba7a5d2a400e2380e0a01bc55ccd8008ec"
    sha256 cellar: :any,                 monterey:       "45fa6ae0fcff324d369102c40df0e6d059f2f433100d3905294eeb7cb18b5443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf500e3876b86dbdc97fded9a23a01216fe02772e008f9010530d0ddbe88cbcf"
  end

  depends_on "openjdk" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "ampl-mp"
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  resource "mumps" do
    # follow links provided in official repo: https://github.com/coin-or-tools/ThirdParty-Mumps/blob/stable/3.0/get.Mumps
    url "http://coin-or-tools.github.io/ThirdParty-Mumps/MUMPS_5.6.2.tar.gz"
    mirror "http://deb.debian.org/debian/pool/main/m/mumps/mumps_5.6.2.orig.tar.gz"
    sha256 "13a2c1aff2bd1aa92fe84b7b35d88f43434019963ca09ef7e8c90821a8f1d59a"

    patch do
      # MUMPS does not provide a Makefile.inc customized for macOS.
      on_macos do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/ab96a8b8e510a8a022808a9be77174179ac79e85/ipopt/mumps-makefile-inc-generic-seq.patch"
        sha256 "0c570ee41299073ec2232ad089d8ee10a2010e6dfc9edc28f66912dae6999d75"
      end

      on_linux do
        url "https://gist.githubusercontent.com/dawidd6/09f831daf608eb6e07cc80286b483030/raw/b5ab689dea5772e9b6a8b6d88676e8d76224c0cc/mumps-homebrew-linux.patch"
        sha256 "13125be766a22aec395166bf015973f5e4d82cd3329c87895646f0aefda9e78e"
      end
    end
  end

  resource "test" do
    url "https://github.com/coin-or/Ipopt/archive/refs/tags/releases/3.14.15.tar.gz"
    sha256 "98c9bf2a7eb3c82f2a68d59dbe5cd87370539ade144b0553370730ccd98cf143"
  end

  def install
    ENV.delete("MPICC")
    ENV.delete("MPICXX")
    ENV.delete("MPIFC")

    resource("mumps").stage do
      cp "Make.inc/Makefile.inc.generic.SEQ", "Makefile.inc"
      inreplace "Makefile.inc", "@rpath/", "#{opt_lib}/" if OS.mac?

      # Fix for GCC 10
      inreplace "Makefile.inc", "OPTF    = -fPIC",
                "OPTF    = -fPIC -fallow-argument-mismatch"

      ENV.deparallelize { system "make", "d" }

      (buildpath/"mumps_include").install Dir["include/*.h", "libseq/mpi.h"]
      lib.install Dir[
        "lib/#{shared_library("*")}",
        "libseq/#{shared_library("*")}",
        "PORD/lib/#{shared_library("*")}"
      ]
    end

    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--enable-shared",
      "--prefix=#{prefix}",
      "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-mumps-cflags=-I#{buildpath}/mumps_include",
      "--with-mumps-lflags=-L#{lib} -ldmumps -lmpiseq -lmumps_common -lopenblas -lpord",
      "--with-asl-cflags=-I#{Formula["ampl-mp"].opt_include}/asl",
      "--with-asl-lflags=-L#{Formula["ampl-mp"].opt_lib} -lasl",
    ]

    system "./configure", *args
    system "make"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    testpath.install resource("test")
    pkg_config_flags = `pkg-config --cflags --libs ipopt`.chomp.split
    system ENV.cxx, "examples/hs071_cpp/hs071_main.cpp", "examples/hs071_cpp/hs071_nlp.cpp", *pkg_config_flags
    system "./a.out"
    system "#{bin}/ipopt", "#{Formula["ampl-mp"].opt_pkgshare}/example/wb"
  end
end
