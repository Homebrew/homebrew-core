class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.7.7.tar.gz"
  sha256 "ddfc4df39a1da01c5e7503db59340c3b287741b5d0cb710f94f5f7551f41c888"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "0760ab589f4a99cb3758f829d472c1b4491fdfeccce1f3cf288332df23445f9f"
    sha256 cellar: :any, catalina: "a7c7b8f14de7319453e1e7818e326620f3dc56c597fc329c38e63dc77e6cbc7e"
    sha256 cellar: :any, mojave:   "744a50ec6395c47b80ce450d029907486ea1db8f040d0dc95032d0535e0f3b6a"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

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
