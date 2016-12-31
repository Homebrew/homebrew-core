class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.10.0.tar.gz"
  sha256 "d2be64412efafb10401c3a4916c9f917bbe7ab9d1fe6562de24c5f578a9383ef"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "5f63d89e3e38f4228b8ea7439c885e903aacecba90a7560d318ef57da68a3baf" => :sierra
    sha256 "83dc135f67b5edc2865e1943c9c5acfe13fc89198f32e82b19279d77ce5c1cfd" => :el_capitan
    sha256 "0d2453059f41a1a6ee1c50a35a78714df5e5d411ab2ea3da136625b86b4eda58" => :yosemite
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
