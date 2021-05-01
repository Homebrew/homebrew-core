class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://github.com/coin-or/Ipopt/archive/releases/3.13.4.tar.gz"
  sha256 "1fdd0f8ea637856d66b1ebdd7d52ad1b8b8c1142d1a4ce0976b200ab280e5683"
  license "EPL-1.0"
  revision 1
  head "https://github.com/coin-or/Ipopt.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b565cf2a619ac1925cda935b9ded13ee66f339d8d87716eff7778ea6e8364d9c"
    sha256 cellar: :any, big_sur:       "3b0388a537a291d3078a67cccceff9b3d26042a868da1a48fef3dde71d33f26e"
    sha256 cellar: :any, catalina:      "40f3152e3f24b107acad92e645391ffdee423210a1af5e2c0d286ab14aa92d5b"
    sha256 cellar: :any, mojave:        "13409cd330a4e313b67044d868618168dfd2e6c0adf8ff660243c3afedfada4b"
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
    url "https://github.com/coin-or/Ipopt/archive/releases/3.13.4.tar.gz"
    sha256 "1fdd0f8ea637856d66b1ebdd7d52ad1b8b8c1142d1a4ce0976b200ab280e5683"
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
