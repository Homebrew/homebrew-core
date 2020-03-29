class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.4.1.tar.gz"
  sha256 "f5e2e10133d2a266e508db9d95e425108a1a7e43ca713bedd0d9005d962b0cff"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "89fab3d26b522506a9b3736428886040e8f79e7e225d820f8eb2a51e0046b784" => :catalina
    sha256 "177323026db46953efa7277e0181615d79e9405c85ea6f201d51ce789f4b9a20" => :mojave
    sha256 "13865a1211b42a9f43c4a2db0ccb046a59e6a66e82c24edc02669f9c3acdc122" => :high_sierra
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
