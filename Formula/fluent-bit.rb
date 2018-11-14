class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.14.6.tar.gz"
  sha256 "eb4f37b83b8311dd4a3a4a3545a1c1d634495e2e4faf342b8e319b8baadb403f"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "a10ad4d893e98e2cd49ab384a4146052f989fc63c3e6d3090d2103cefc307b3e" => :mojave
    sha256 "4f18c37d08c025e590dd43b629e5f60744d2b49481269897a470ff055031f4b7" => :high_sierra
    sha256 "c01e0a950854873d3a3faee3211a4d6feff1b7f69fabf3a61be88ba17923d6e2" => :sierra
  end

  depends_on "cmake" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."
  conflicts_with "msgpack", :because => "fluent-bit includes msgpack libraries."

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
