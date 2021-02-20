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
    sha256 cellar: :any, big_sur:  "28b59180337f1eddae3761345d59344ba78f86265d61a478670e84c1eea47ea0"
    sha256 cellar: :any, catalina: "39e5a8636a347ffc07f6800502064a3855e02baccfb2dc82b350b9fe508d9247"
    sha256 cellar: :any, mojave:   "cdfdb454a0e0f9cabcf2a023bbede874505967a3e9c6bfc7918f488ae06c1e27"
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
