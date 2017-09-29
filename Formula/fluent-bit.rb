class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.4.tar.gz"
  sha256 "bf4884bcac3913ac80ba19b84b53f65b9c2c30a084ca057c2d3552d722c5db59"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "4d2f9bd7a05a5e11c82963283729b8f49c5d1b57585759247d081fe20f644853" => :high_sierra
    sha256 "ce6b35ed23363fc72f3653b367fcc4efffd5184f6a7ea07ca04b787dda11bc98" => :sierra
    sha256 "5cb531e4ac37bd201d547509238bbce4a3b6869a89563d02d80fd851e1395afd" => :el_capitan
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
