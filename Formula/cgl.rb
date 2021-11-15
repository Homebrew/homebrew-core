class Cgl < Formula
  desc "Cut Generation Library"
  homepage "https://github.com/coin-or/Cgl"
  url "https://github.com/coin-or/Cgl/archive/releases/0.60.3.tar.gz"
  sha256 "cfeeedd68feab7c0ce377eb9c7b61715120478f12c4dd0064b05ad640e20f3fb"
  license "EPL-1.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "22a1b60daec4025069498452fef640837d4cf77618aa587b728365ac09c69458"
    sha256 cellar: :any,                 monterey:      "a4bce4cbcb490d1ae1393718f808d5a12f81ed8f721716466f76fb17dc3ea9b9"
    sha256 cellar: :any,                 big_sur:       "17536b04cb964956f52a00e5c3629c2d94d85bfe1317f6b57e141af71cf7ad2e"
    sha256 cellar: :any,                 catalina:      "6eb179515b4cf06ad8bb484e6384f6cdae99297f523372b082ef079ed84cafd4"
    sha256 cellar: :any,                 mojave:        "acdb179fb8b29973e75a674a12fa24f164b753300c625f1a4dc3ca8f3cd9dcf4"
    sha256 cellar: :any,                 high_sierra:   "2cc6712792b9b5fec15ec479492f4da50f371ce37af53fece6bce474f93cf336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6220599a7bc6d47dd172158615293ef62b40e5ef5337d4f50dfd01081451cb41"
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
