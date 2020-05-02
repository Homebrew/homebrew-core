class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.4.3.tar.gz"
  sha256 "3f3e5fa98253170cfaa10838fafc43e34309e8870ef574e2e19ab96bf4217d90"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "0f399529b3f639a021c16163ee776592c46f29c223e68c3ae0b2bb30a20da867" => :catalina
    sha256 "87eb244c5c8b0c8d8170375e65933bc07d46386aaae210ffedf9f2f49907eba1" => :mojave
    sha256 "434cb83c602ec07c2898463479ae66ca817d040b5cb33f6d2af926a6390980de" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."
  conflicts_with "msgpack", :because => "fluent-bit includes msgpack libraries."

  def install
    # Work around Xcode 11 clang bug
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

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
