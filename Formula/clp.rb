class Clp < Formula
  desc "Linear programming solver"
  homepage "https://github.com/coin-or/Clp"
  url "https://github.com/coin-or/Clp/archive/releases/1.17.7.tar.gz"
  sha256 "c4c2c0e014220ce8b6294f3be0f3a595a37bef58a14bf9bac406016e9e73b0f5"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^(?:releases/)?v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b933a8e00e77e296fac88f9e9f4df486684b9af8329fba8d016f8b2359469ebc"
    sha256 cellar: :any,                 arm64_monterey: "17d872a7aa2ec5f8f1cb3759bd69139e100c13000fbe11a5fad9aaf6dc8317f2"
    sha256 cellar: :any,                 arm64_big_sur:  "cec830295042bd72147eda6e79e1c0a54f1fca05af181ab34f719fb3fd55f06b"
    sha256 cellar: :any,                 ventura:        "5379a136549d8a2631262c43425399f1a9d708a56cb1c2ab66637e7cf5cabfa7"
    sha256 cellar: :any,                 monterey:       "b3e651293949113d80f1156bfc5a13c50f65f7e8019471995f80b95f16227276"
    sha256 cellar: :any,                 big_sur:        "0f6eed77fe4689ca6c0c1765a57bca96aa02b032df3efb614b8be6efb93efac1"
    sha256 cellar: :any,                 catalina:       "565b7866cfc9dd3866a7fd0212408fe35951e3ffdadf9c4e2360a7b0388b6e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3dad68c532f478c9bf2299a8babfdf18b84db64ac6810130998804a86ab9757"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "coinutils"
  depends_on "openblas"
  depends_on "osi"

  resource "coin-or-tools-data-sample-p0033-mps" do
    url "https://raw.githubusercontent.com/coin-or-tools/Data-Sample/releases/1.2.12/p0033.mps"
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
