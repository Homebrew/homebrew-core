class Clp < Formula
  desc "Linear programming solver"
  homepage "https://github.com/coin-or/Clp"
  url "https://github.com/coin-or/Clp/archive/releases/1.17.3.tar.gz"
  sha256 "25f0692fe1daa492e7801770af6991506ae9a8c34a4cae358d017400a02dfcf8"

  bottle do
    cellar :any
    sha256 "8fbdf09232ec254499190aa1ded5d7b1ef9afceee52152d06015e372693e0f0f" => :catalina
    sha256 "47405e6eaa81067d591c0b71bf2eca12e8e3452e74f4038142c5c79955924913" => :mojave
    sha256 "a4e37c5c28ccc68d31609142021b79f3ae6e88279a9cef7380e05c13fdfc3042" => :high_sierra
    sha256 "9ad0b39ec4c454bb43433099dcceb152a29418d5d33a4b8049155b4861940979" => :sierra
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "coinutils"
  depends_on "openblas"

  resource "coin-or-tools-data-sample-p0033-mps" do
    url "https://raw.githubusercontent.com/coin-or-tools/Data-Sample/releases/1.2.11/p0033.mps"
    sha256 "8ccff819023237c79ef32e238a5da9348725ce9a4425d48888baf3a0b3b42628"
  end

  def install
    # Work around https://github.com/coin-or/Clp/issues/109:
    # Error 1: "mkdir: #{include}/clp/coin: File exists."
    mkdir include/"clp/coin"

    args = [
      "--datadir=#{pkgshare}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--includedir=#{include}/clp",
      "--prefix=#{prefix}",
      "--with-blas-incdir=#{Formula["openblas"].opt_include}",
      "--with-blas-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-lapack-incdir=#{Formula["openblas"].opt_include}",
      "--with-lapack-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    resource("coin-or-tools-data-sample-p0033-mps").stage testpath
    system bin/"clp", "-import", testpath/"p0033.mps", "-primals"
    (testpath/"test.cpp").write <<~EOS
      #include <ClpSimplex.hpp>
      int main() {
        ClpSimplex model;
        int status = model.readMps("#{testpath}/p0033.mps", true);
        if (status != 0) { return status; }
        status = model.primal();
        return status;
      }
    EOS
    pkg_config_flags = `pkg-config --cflags --libs clp`.chomp.split
    system ENV.cxx, "test.cpp", *pkg_config_flags
    system "./a.out"
  end
end
