class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.14.6.tar.gz"
  sha256 "eb4f37b83b8311dd4a3a4a3545a1c1d634495e2e4faf342b8e319b8baadb403f"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "7430940765367c3b3256105bfd21eefa3b372b545c3a33088e76bd61b66b45c1" => :mojave
    sha256 "2655660c9fef404bb19e4fb74e5a849685ae3d917742a5f0a43d0bf9a969693d" => :high_sierra
    sha256 "abfd2c1976434967ce92503d4819ff2042a9f8f0244d127740ad6de888c471a8" => :sierra
    sha256 "f404dd3a5527bb00bbecc9c94ce80916b5cb8622cfc4480cd7aaa6833f0b5875" => :el_capitan
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
