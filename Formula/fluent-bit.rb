class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.13.8.tar.gz"
  sha256 "0c3235974d003b4e6979f7944bdc01df46eb8672ceef89dc537ca3e23742b765"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "6e9fc7fa9be555b51fcfaca234a11ecf4f7ec8e4e4e433c24afbd43980a53218" => :high_sierra
    sha256 "37e5789f3d2a8d60c9c49b40dc31b880004fbdc7a202fe7c9b94d9029152377f" => :sierra
    sha256 "5ffcfbb9c488901e542b8264b1fd3c066bd52f814ebd8464a28ca721cce0f738" => :el_capitan
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
