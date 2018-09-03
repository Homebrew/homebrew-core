class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.14.1.tar.gz"
  sha256 "0879e5801f56d56d75462bdb9505cf1fb061797444560dd7657fa2c311532111"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "7068d579c5350b13fcd01c87641c3a7766867bc4e54c8304623db48619f5d884" => :mojave
    sha256 "5f0d22d71f036cff55449e0d4184c170f242e767cdcab057059c5d5abef94348" => :high_sierra
    sha256 "0137ff058a98542ef6f0f8bc720dc9bb47581bf710acb8823a7ff901d6b50898" => :sierra
    sha256 "406b7027ca2b9e9fcdf12e0790c12aab4f3f55414f045c3b03ebad6651dd5d6a" => :el_capitan
  end

  depends_on "cmake" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."
  conflicts_with "msgpack", :because => "fluent-bit includes msgpack libraries."

  def install
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit ships an embedded Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
