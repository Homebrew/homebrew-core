class Cgl < Formula
  desc "Cut Generation Library"
  homepage "https://github.com/coin-or/Cgl"
  url "https://github.com/coin-or/Cgl/archive/releases/0.60.6.tar.gz"
  sha256 "9e2c51ffad816ab408763d6b931e2a3060482ee4bf1983148969de96d4b2c9ce"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cea5e33d3a1cd912c38bc558e8c962b0ea0495820fa69b1fc29f5fb2d1386dd4"
    sha256 cellar: :any,                 arm64_big_sur:  "7d100e6e8d3f9366d113cb527c4022c4be871fbab16c9b071d9d3abe9bffd8c1"
    sha256 cellar: :any,                 monterey:       "4fedffb360740c5faa5bf6b62ae7d451e2d7a4cba55da63f8ed760c95458368e"
    sha256 cellar: :any,                 big_sur:        "3c01eba7f47e4fb1bbac2f98f44333e1728ebde00d1ec8439b8c69c8b800bb53"
    sha256 cellar: :any,                 catalina:       "b32056388c0fe4872ba562a456618e4b51cbfd8fb4d92be6c6a16cd53dc08cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81891856e66351a118b8f8640fc6509a10ea93936d46f3ca59132dc3e7a03f5f"
  end

  depends_on "pkg-config" => :build
  depends_on "clp"
  depends_on "coinutils"
  depends_on "osi"

  resource "coin-or-tools-data-sample-p0033-mps" do
    url "https://raw.githubusercontent.com/coin-or-tools/Data-Sample/releases/1.2.11/p0033.mps"
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
