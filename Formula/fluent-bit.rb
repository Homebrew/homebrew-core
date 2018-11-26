class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.14.8.tar.gz"
  sha256 "aca598bb3ea1e25fc43c53781445e2f1eca7c792335bd0144e29b1ecabc7309d"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "1eaa2c89a1314b8141934d47237352ee8da66d00bc37b8e1fb101e5090389b1e" => :mojave
    sha256 "7bb89890071a561f03db1dd2354cca551dde1bc09539dcc1ac520bbc177b1fa3" => :high_sierra
    sha256 "6a0f30df285587ece535fb10b4f084270cb0011b5766b103d3364bf9eddd2ded" => :sierra
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
