class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://projects.coin-or.org/Ipopt/"
  url "https://www.coin-or.org/download/source/Ipopt/Ipopt-3.13.2.tgz"
  sha256 "891ab9e9c7db29fc8ac5c779ccec6313301098de7bbf735ca230cd5544c49496"
  head "https://github.com/coin-or/Ipopt.git"

  bottle do
    cellar :any
    sha256 "56da0a54b5c1eb644e881a508886601674c73105a29451f1ca50ba9f9fa9d517" => :catalina
    sha256 "b4c05741141600b85ee8b1ca5c075d8ffcd2c031804ef7830017f16fbb16fa26" => :mojave
    sha256 "d7d32a074eafdcb5e1b4c50e1b4c0cd76cfb09718eaf5ae8f7e5cecbded70b91" => :high_sierra
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

      ENV.deparallelize { system "make", "d" }

      (buildpath/"mumps_include").install Dir["include/*.h", "libseq/mpi.h"]
      lib.install Dir["lib/*.dylib", "libseq/*.dylib", "PORD/lib/*.dylib"]
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
