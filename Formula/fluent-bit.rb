class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.8.1.tar.gz"
  sha256 "f59964c454836b8806d5d358e6a03d86df4d98098bec1a1dbbc98b2c2f2f491b"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "7b1195afb3f8db710f357b54cdce15df760b5a750c2a6558a13db45619506290" => :el_capitan
    sha256 "6ec3a37d4a9004969963d77ec2f47e6de9da8f72b83c59567f58c34bbf4c90dc" => :yosemite
    sha256 "27f7a79bc4b756a7623a9432c049f7c85698c8552adf1df1e83bcc2a24fed737" => :mavericks
  end

  depends_on "cmake" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."

  def install
    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    io = IO.popen("#{bin}/fluent-bit --input stdin --output stdout --daemon")
    sleep 1
    Process.kill("SIGINT", io.pid)
    Process.wait(io.pid)
    assert_match(/Fluent-Bit v#{version}/, io.read)
  end
end
