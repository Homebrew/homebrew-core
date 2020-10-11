class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://github.com/coin-or/Ipopt/archive/releases/3.12.13.tar.gz"
  sha256 "ab8b9457dc6c7240a45e74b4a3851821ccafc2927cfa5c8998e95941d67a94d0"
  license "EPL-1.0"
  revision 9
  head "https://github.com/coin-or/Ipopt.git"

  bottle do
    cellar :any
    sha256 "d7a39ffbd4228581ca59ffb091b997aebd40a41038c60809baea596ebcd2e871" => :catalina
    sha256 "1147231684595f18ffe44e3a2852ece5456fc4dbfe7455f6a853dd4ef4e055c0" => :mojave
    sha256 "4d9b8a8cc3091182b49fd4a38bf55f4ca7e953d326af64e247db419c42f8859c" => :high_sierra
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "gcc"
  depends_on "openblas"

  resource "mumps" do
    url "http://mumps.enseeiht.fr/MUMPS_5.2.1.tar.gz"
    sha256 "d988fc34dfc8f5eee0533e361052a972aa69cc39ab193e7f987178d24981744a"

    # MUMPS does not provide a Makefile.inc customized for macOS.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/ab96a8b8e510a8a022808a9be77174179ac79e85/ipopt/mumps-makefile-inc-generic-seq.patch"
      sha256 "0c570ee41299073ec2232ad089d8ee10a2010e6dfc9edc28f66912dae6999d75"
    end
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
      "--with-mumps-incdir=#{buildpath}/mumps_include",
      "--with-mumps-lib=-L#{lib} -ldmumps -lmpiseq -lmumps_common -lopenblas -lpord",
    ]

    system "./configure", *args
    system "make"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <IpIpoptApplication.hpp>
      #include <IpReturnCodes.hpp>
      #include <IpSmartPtr.hpp>
      int main() {
        Ipopt::SmartPtr<Ipopt::IpoptApplication> app = IpoptApplicationFactory();
        const Ipopt::ApplicationReturnStatus status = app->Initialize();
        assert(status == Ipopt::Solve_Succeeded);
        return 0;
      }
    EOS
    pkg_config_flags = `pkg-config --cflags --libs ipopt`.chomp.split
    system ENV.cxx, "test.cpp", *pkg_config_flags
    system "./a.out"
  end
end
