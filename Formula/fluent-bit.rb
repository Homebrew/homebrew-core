class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.8.tar.gz"
  sha256 "12c6dad92df6360c25a4448d92480ff649da948f402677f08a21e77b3d0185b9"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "7a515802f8fe140c2e0a28ec27e0bfca178952ea83bc6c3c3ed0650c3eb51467" => :sierra
    sha256 "d623cd8e214644d3a4b3da12c56282297c5c370fc3880c6c6e38d3cb3f70bb9e" => :el_capitan
    sha256 "ef211dc6a2b0729a44c0d82b335dff71d67dd29a42ce46e964b6140d02c0c40f" => :yosemite
  end

  depends_on "cmake" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."
  conflicts_with "msgpack", :because => "fluent-bit includes msgpack libraries."

  def install
    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
