class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://fluentbit.io"
  url "https://github.com/fluent/fluent-bit/archive/v1.0.0.tar.gz"
  sha256 "d8646dafb998f91cf46755cab94d9cc64f5d597a6fae60eb20282aa418ff044b"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "2507e5a3b0f30eaf44f6acf6ab659d3003ff5822d0e279fc1712830af77e8cb4" => :mojave
    sha256 "45f89286b8aa1d5946bec8f5d6ddc9ddfd44cf1be795816f6c7b6e3d018a6055" => :high_sierra
    sha256 "d0136990b48d1fe3f5ac0e7e55b41ac0925404349730605d1f1b38f551cd5b03" => :sierra
  end

  depends_on "cmake" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."
  conflicts_with "msgpack", :because => "fluent-bit includes msgpack libraries."

  def install
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
