class Cgl < Formula
  desc "Cut Generation Library"
  homepage "https://github.com/coin-or/Cgl"
  url "https://github.com/coin-or/Cgl/archive/releases/0.60.5.tar.gz"
  sha256 "5a2e7ca380425b3d7279d0759c625a367d06ec8293698b59f82fae38ae5df64e"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7a3664209bc14f66468af8ca3167c73dd5b45e49f2d0473ffdc24ae314255bf5"
    sha256 cellar: :any,                 arm64_big_sur:  "78f50ec0ae0637b4bb63e0cfc5f8aa2b1c33bd59ed5fed9fa453799e422bacb5"
    sha256 cellar: :any,                 monterey:       "3db74a624646e9a1343e24ddd3e1093433f6c6059e02f5c9c274494ebda0fc92"
    sha256 cellar: :any,                 big_sur:        "2306047175bc143246e45b6073e64b8e1c0452723de9c19cca686193641cf792"
    sha256 cellar: :any,                 catalina:       "2add170c3831b323931a015a8bec7bc9ce7ee32b921a54a15781ddfdfd815c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2cf9250052243fd2875e1b3f6069b58051aee59d75e1588a2fc13501f7605b5"
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
