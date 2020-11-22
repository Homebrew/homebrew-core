class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://www.coin-or.org/download/source/Ipopt/Ipopt-3.13.3.tgz"
  sha256 "86354b36c691e6cd6b8049218519923ab0ce8a6f0a432c2c0de605191f2d4a1c"
  license "EPL-1.0"
  revision 2
  head "https://github.com/coin-or/Ipopt.git"

  bottle do
    cellar :any
    sha256 "c5456fca281c86e78db399f960b2e657e6c8b8d8a1da4d8b799ad14a0c63ff65" => :big_sur
    sha256 "8f0881c3022f0fbba7821e99a766b0fabeeb9551909e44b8fb9436da91329382" => :catalina
    sha256 "d87262af5ab808ba7f5d51491035ce28fcb68c25cea07231b5d32d12a61602ef" => :mojave
  end

  depends_on "openjdk" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "ampl-mp"
  depends_on "gcc"
  depends_on "openblas"

  resource "mumps" do
    url "http://mumps.enseeiht.fr/MUMPS_5.3.5.tar.gz"
    sha256 "e5d665fdb7043043f0799ae3dbe3b37e5b200d1ab7a6f7b2a4e463fd89507fa4"

    # MUMPS does not provide a Makefile.inc customized for macOS.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/ab96a8b8e510a8a022808a9be77174179ac79e85/ipopt/mumps-makefile-inc-generic-seq.patch"
      sha256 "0c570ee41299073ec2232ad089d8ee10a2010e6dfc9edc28f66912dae6999d75"
    end
  end

  resource "test" do
    url "https://www.coin-or.org/download/source/Ipopt/Ipopt-3.13.3.tgz"
    sha256 "86354b36c691e6cd6b8049218519923ab0ce8a6f0a432c2c0de605191f2d4a1c"
  end

  def install
    ENV.delete("MPICC")
    ENV.delete("MPICXX")
    ENV.delete("MPIFC")

    resource("mumps").stage do
      cp "Make.inc/Makefile.inc.generic.SEQ", "Makefile.inc"
      inreplace "Makefile.inc", "@rpath/", "#{opt_lib}/"

      # Fix for GCC 10
      inreplace "Makefile.inc", "OPTF    = -fPIC", "OPTF    = -fPIC -fallow-argument-mismatch"

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
