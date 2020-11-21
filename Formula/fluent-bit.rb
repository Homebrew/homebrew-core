class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.6.5.tar.gz"
  sha256 "3c1d0db7d76ac357bb183f872b71b3534e367b3ee4cfb18109039ed4b3d43623"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "929069873aec3eb8a8f41493c002b264090b5cb0c870407627a4e843522d0bec" => :big_sur
    sha256 "c15f094578a3ffe062d6c193b63d71e595a9109a8f2c465b9bdeb0a65be2d733" => :catalina
    sha256 "3daa1172a7bc26e62d39089d3a08e1ce4e13e4f5867acba3f2c19bf2498bcc62" => :mojave
    sha256 "ef0a9982ee85ff2eecb067a2e23734f88de376a029e6b68a3eb66aa9673887a4" => :high_sierra
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
