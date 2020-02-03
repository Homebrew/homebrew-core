class Clp < Formula
  desc "Linear programming solver"
  homepage "https://github.com/coin-or/Clp"
  url "https://github.com/coin-or/Clp/archive/releases/1.17.5.tar.gz"
  sha256 "7e2856ef7cab4bc1a439756cf101d5184a7af09d2921452a22a459ac8f949b7b"

  bottle do
    cellar :any
    sha256 "aec21dce0e4f3971e9faa18a70fba7392086c6bada4824bda9a11bda368bef16" => :catalina
    sha256 "aa1175a45c885f3e5a5b33a6f45efcc5aa3c256d9b0b9a8e19b3f950afb65c19" => :mojave
    sha256 "4e2f34f8b83d7f0819516349deac011895a545a7768f941b7b31a03277f0b8db" => :high_sierra
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
