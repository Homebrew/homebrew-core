class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://github.com/coin-or/Ipopt/archive/releases/3.14.4.tar.gz"
  sha256 "60865150b6fad19c5968395b57ff4a0892380125646c3afa2a714926f5ac9487"
  license "EPL-1.0"
  head "https://github.com/coin-or/Ipopt.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ed14dc7358fe73373f237fb4d282ba8f1e744af8b7b851e799fe99d7e507d487"
    sha256 cellar: :any,                 monterey:      "62a0abe6151b8c3a6d38591f5cef5eedca317d42f836f7dea05766f49ea70718"
    sha256 cellar: :any,                 big_sur:       "86f5e863ace34e7e65aeade03cb700a5f8749bc6c5912e85a42ae5316fc148b3"
    sha256 cellar: :any,                 catalina:      "7ee50053077dbbbe2f8f8597c9f2a8ea7b9ec279789b07b17271a03e63978a4d"
    sha256 cellar: :any,                 mojave:        "082977c7306528c34fec92cf501b30788c4e6e2da025155f449887d099a060fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09d25507147da744581f9522b2d1900d6a17eb615d69300630a482658a769662"
  end

  depends_on "openjdk" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "ampl-mp"
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  resource "mumps" do
    url "http://mumps.enseeiht.fr/MUMPS_5.4.0.tar.gz"
    sha256 "c613414683e462da7c152c131cebf34f937e79b30571424060dd673368bbf627"

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
    url "https://github.com/coin-or/Ipopt/archive/releases/3.14.4.tar.gz"
    sha256 "60865150b6fad19c5968395b57ff4a0892380125646c3afa2a714926f5ac9487"
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
