class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.14.8.tar.gz"
  sha256 "aca598bb3ea1e25fc43c53781445e2f1eca7c792335bd0144e29b1ecabc7309d"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "670046e649d22447f9154c71a8ad46d5e1ce2b4b1fa835fde4c35bb8c641b9d0" => :mojave
    sha256 "bdd441d961d680c3891b89f94f6122dd019c472eaf39abfc38099de51cd9c2de" => :high_sierra
    sha256 "cd4d0064791a3eb2f736b8e7d11be48cb88307474c378dea04b59a7d54282ac6" => :sierra
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
