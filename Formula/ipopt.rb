class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://projects.coin-or.org/Ipopt/"
  url "https://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.13.tgz"
  sha256 "aac9bb4d8a257fdfacc54ff3f1cbfdf6e2d61fb0cf395749e3b0c0664d3e7e96"
  revision 6
  head "https://github.com/coin-or/Ipopt.git"

  bottle do
    cellar :any
    sha256 "e01bf31da58fc38890f1e03589728dca333977d1430c64364e17f6a1a237ab84" => :catalina
    sha256 "1b1b288dc7a6cecc6b9c8b948cf3e20b31fd07364e0d34bf481eeee6dd1e71c8" => :mojave
    sha256 "cd33bba49eacdc431c57500683b4e5f61d94d68e72dba56b1c69110fb74c562e" => :high_sierra
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
