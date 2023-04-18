class Cgl < Formula
  desc "Cut Generation Library"
  homepage "https://github.com/coin-or/Cgl"
  url "https://github.com/coin-or/Cgl/archive/releases/0.60.7.tar.gz"
  sha256 "93b30a80b5d2880c2e72d5877c64bdeaf4d7c1928b3194ea2f88b1aa4517fb1b"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3ddd93328f7b4eb4ecfaf4dac9164827b49034a2bbbca9ac03901d87ca8dd6ce"
    sha256 cellar: :any,                 arm64_monterey: "44c8ab710a85a522bae175ac78395e368296cb07bde774805aab214dfb854d99"
    sha256 cellar: :any,                 arm64_big_sur:  "677dddccb79e3389d017a91a4e4da553c58868ff56185891e02d62567f4ce486"
    sha256 cellar: :any,                 ventura:        "642be86f74cf36155df032886103b2fa76434b8d297f36c352667c945e964c54"
    sha256 cellar: :any,                 monterey:       "15e126b054f035a2de747d098d2fd4d9f2c3ff3395607784257cde9544ffb13c"
    sha256 cellar: :any,                 big_sur:        "b778532577e8b296512ed07940c17019002695c766bbce50c6271d0c0a69d8c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c164298d488e8e71948514edd97154453299a62cf2026306224e24e595297a3d"
  end

  depends_on "pkg-config" => :build
  depends_on "clp"
  depends_on "coinutils"
  depends_on "osi"

  resource "coin-or-tools-data-sample-p0033-mps" do
    url "https://raw.githubusercontent.com/coin-or-tools/Data-Sample/releases/1.2.12/p0033.mps"
    sha256 "8ccff819023237c79ef32e238a5da9348725ce9a4425d48888baf3a0b3b42628"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--includedir=#{include}/cgl"
    system "make"
    system "make", "install"
    pkgshare.install "Cgl/examples"
  end

  test do
    resource("coin-or-tools-data-sample-p0033-mps").stage testpath
    cp pkgshare/"examples/cgl1.cpp", testpath
    system ENV.cxx, "-std=c++11", "cgl1.cpp",
                    "-I#{include}/cgl/coin",
                    "-I#{Formula["clp"].opt_include}/clp/coin",
                    "-I#{Formula["coinutils"].opt_include}/coinutils/coin",
                    "-I#{Formula["osi"].opt_include}/osi/coin",
                    "-L#{lib}", "-lCgl",
                    "-L#{Formula["clp"].opt_lib}", "-lClp", "-lOsiClp",
                    "-L#{Formula["coinutils"].opt_lib}", "-lCoinUtils",
                    "-L#{Formula["osi"].opt_lib}", "-lOsi",
                    "-o", "test"
    output = shell_output("./test p0033 min")
    assert_match "Cut generation phase completed", output
  end
end
