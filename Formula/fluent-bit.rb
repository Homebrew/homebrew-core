class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.3.10.tar.gz"
  sha256 "38b614a8e4cc9b4cc0fc06766fe6c0d815918fe23b0cc02dda31a38910abf184"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "0dd791b074a5b9806dfe863fc6a117a8631bb2053af7b3011f94b5fa10298032" => :catalina
    sha256 "ffa38513e557430010ceaaa2d868e9aeec1a1e35844dcd30a8d5b9ca4410c8e1" => :mojave
    sha256 "06d4d5ddf1d7f87f5765f77a0bf803fd1a0bd522d26b0b4e30644268f0f1a264" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

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
