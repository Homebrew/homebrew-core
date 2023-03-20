class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://github.com/coin-or/Ipopt/archive/releases/3.14.11.tar.gz"
  sha256 "0b5355f9b7212721357ef0a28184c6e47b67902a9cfc8b4d77a1fd405e4ddb10"
  license "EPL-2.0"
  head "https://github.com/coin-or/Ipopt.git", branch: "stable/3.14"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "15825156db8d101cd5c0ebb6e91277573c3e207d4528f1d30e2202c21de9311e"
    sha256 cellar: :any,                 arm64_monterey: "eb45be294a23e666bf8bc60d452c7fb74ea3a2ebf223f9eb901daa22b66af125"
    sha256 cellar: :any,                 arm64_big_sur:  "0e34845f5b2e55a2785d1a5c2c3784d28614603e9776010e03aeae426a915889"
    sha256 cellar: :any,                 ventura:        "384f76cade74c04ad4fb1aacb76249b2174a1fb7c47ea318960f9e978df2e4d0"
    sha256 cellar: :any,                 monterey:       "1289d2874116bea34f410a18ca741a342688f87899bcae619b069caf99a38293"
    sha256 cellar: :any,                 big_sur:        "f00a4ead66c37798e039bc1267892d262f7b0f2c1ddc92f16e01ff879c92d6f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49b7cca07f1bd6e08d8d0f19b8e3b1faa6033cc819f6ea15586a38be175b1d3c"
  end

  depends_on "openjdk" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "ampl-mp"
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  resource "mumps" do
    # follow links provided in official repo: https://github.com/coin-or-tools/ThirdParty-Mumps/blob/stable/3.0/get.Mumps
    url "http://coin-or-tools.github.io/ThirdParty-Mumps/MUMPS_5.5.1.tar.gz"
    mirror "http://deb.debian.org/debian/pool/main/m/mumps/mumps_5.5.1.orig.tar.gz"
    sha256 "1abff294fa47ee4cfd50dfd5c595942b72ebfcedce08142a75a99ab35014fa15"

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
    url "https://github.com/coin-or/Ipopt/archive/releases/3.14.11.tar.gz"
    sha256 "0b5355f9b7212721357ef0a28184c6e47b67902a9cfc8b4d77a1fd405e4ddb10"
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
