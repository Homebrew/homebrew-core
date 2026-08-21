class Cgl < Formula
  desc "Cut Generation Library"
  homepage "https://github.com/coin-or/Cgl"
  url "https://github.com/coin-or/Cgl/archive/refs/tags/releases/0.60.10.tar.gz"
  sha256 "41b7ac9402db883d9c487eb7101e59eb513cefd726e6e7a669dc94664d9385e6"
  license "EPL-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ea3fb77acf4c37b612b9b679d107a72816e5b649252d6e81e3257041a2d08e5"
    sha256 cellar: :any,                 arm64_sequoia: "e33e192a6cb3365113015774ee902ddb2a720088eea8ed1a798a1a1fbaac4fa1"
    sha256 cellar: :any,                 arm64_sonoma:  "968fb4202fc8df229fe86cdbab0b410a42df20a4435f0ed6ea2fd35d55d63ce9"
    sha256 cellar: :any,                 sonoma:        "1a63ce22fdd51c336c7d4ba64240b29f6fa5e548bc007f28186b9f62345d8dac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee2ddfbd7c3f9e85937d596e6a3fc526718178c10303e4438fd292828e4211ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aaa762baad6596687a1ee66a677e5c6346bb94b6b48ecc95b6f8cb8352c03c8"
  end

  depends_on "pkgconf" => [:build, :test]

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
