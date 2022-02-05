class Cgl < Formula
  desc "Cut Generation Library"
  homepage "https://github.com/coin-or/Cgl"
  url "https://github.com/coin-or/Cgl/archive/releases/0.60.5.tar.gz"
  sha256 "5a2e7ca380425b3d7279d0759c625a367d06ec8293698b59f82fae38ae5df64e"
  license "EPL-1.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "af9edac79ea0f5a8fc30db1f281d43d547f360c62ffd00c2fd95219385852c13"
    sha256 cellar: :any,                 arm64_big_sur:  "1de3f2f7dc22b420586f44b2a0440b80da4aa61e31eed16c17a9fa99e7442a56"
    sha256 cellar: :any,                 monterey:       "f0efe4ad0f85197708bb5b352379955d8d402e9afefc9e354ee65c2d165fa490"
    sha256 cellar: :any,                 big_sur:        "7c9411b0cfd540da672c2260557ea1a31ae1bbf5aa444edaf70bbb8e4beb1dd5"
    sha256 cellar: :any,                 catalina:       "47af428c9a8930916eaf4817bf20960c76adc968cb419ef95509e462eac7f3fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bdcd0ff443d36ac99f79625ea0e1b92e371883175db2f895dd8abc0874afcc6"
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
