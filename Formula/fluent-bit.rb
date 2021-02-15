class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.7.0.tar.gz"
  sha256 "1180c691688af9a411a846721ab0c8f4d496fae0dcca6915e4de3641cbd32425"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "3e0bd4c685abfcb34a5c4dd7ff3dfc4637aab7a5fd49d4e79ecc4a58dcc2d69a"
    sha256 cellar: :any, catalina: "f6680841689ed0fcc769d13312900bb3cf05a995c51e757e4ad61cc8b8d9ae01"
    sha256 cellar: :any, mojave:   "39502cff7fd4466b90c5ce6f3586ac25809ee098a619976dc45ed1b23f923653"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  def install
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
