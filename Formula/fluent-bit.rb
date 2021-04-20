class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.7.4.tar.gz"
  sha256 "4ef144e429e3ac8583dbc9b2679f0dc70851e116ff0fc73dafcbe8ba7252ec31"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "3130add51c9c4e127b22e679be8a3ea943e953c6271ff17e98661c0a6115a8f4"
    sha256 cellar: :any, catalina: "9fbfe4aca7a26e4b726c0afd06d58bb4436021a0eb9e53c91839912cf906c5aa"
    sha256 cellar: :any, mojave:   "b1a63baaec354c72ba5114457b2763e889b6ff1ae49c819f572b989f7cd301bf"
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
