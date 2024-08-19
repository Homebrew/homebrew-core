class Cgl < Formula
  desc "Cut Generation Library"
  homepage "https://github.com/coin-or/Cgl"
  url "https://github.com/coin-or/Cgl/archive/refs/tags/releases/0.60.8.tar.gz"
  sha256 "1482ba38afb783d124df8d5392337f79fdd507716e9f1fb6b98fc090acd1ad96"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eb184b558b0128a3815da6c1cd4acc04f14657a08744d1c8074cbebbc888dad2"
    sha256 cellar: :any,                 arm64_ventura:  "72b917dff5690c0ddee0375cc36310eb32669ce903b4da0c5188bdbbb6891810"
    sha256 cellar: :any,                 arm64_monterey: "7f2e18f67025c78173ebc06993a4fa83310d751b39c29579e9eafe42f3777461"
    sha256 cellar: :any,                 sonoma:         "fd9938c8389e8337f963475f8d39e62dfab3ed14c6ee4eb9f0a9cff9d91ea761"
    sha256 cellar: :any,                 ventura:        "181b3c9e8b6c3fe4882f27cc285dc1ca612393bc94141b044832151f084f77cd"
    sha256 cellar: :any,                 monterey:       "ac4c93b86cf20ead288e873761ebbe77028af5fc33c92372861cfb7e062fd799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89e4dd779e9418110fea45a3511a35d711089aa94a15e8096115bba9ef14169a"
  end

  depends_on "pkg-config" => [:build, :test]

  depends_on "clp"
  depends_on "coinutils"
  depends_on "osi"

  on_macos do
    depends_on "openblas"
  end

  def install
    system "./configure", "--disable-silent-rules", "--includedir=#{include}/cgl", *std_configure_args
    system "make", "install"

    pkgshare.install "Cgl/examples"
  end

  test do
    resource "homebrew-coin-or-tools-data-sample-p0033-mps" do
      url "https://raw.githubusercontent.com/coin-or-tools/Data-Sample/releases/1.2.12/p0033.mps"
      sha256 "8ccff819023237c79ef32e238a5da9348725ce9a4425d48888baf3a0b3b42628"
    end

    resource("homebrew-coin-or-tools-data-sample-p0033-mps").stage testpath
    cp pkgshare/"examples/cgl1.cpp", testpath

    pkg_config_flags = shell_output("pkg-config --cflags --libs cgl").chomp.split
    system ENV.cxx, "-std=c++11", "cgl1.cpp", *pkg_config_flags, "-o", "test"
    output = shell_output("./test p0033 min")
    assert_match "Cut generation phase completed", output
  end
end
