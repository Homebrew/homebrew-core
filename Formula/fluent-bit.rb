class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.3.4.tar.gz"
  sha256 "57d36332a28c14686c35798465a614df5bc0e934fadfcfdedb9e3013c2e14129"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "c52d01b19a2c5a987ca8249cdad3a7a8347616b6c50979695c5cd77f95ea60ca" => :catalina
    sha256 "61896d376714db5bd2c25c6c1e62c04cf84fb854fce78c73a6dbedb0d024b239" => :mojave
    sha256 "f0f8c505f2cc9edbe5bca2d26d775a75a89eb138f078b9e5f465b6fef2a9d1de" => :high_sierra
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
