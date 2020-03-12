class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/v1.3.0.tar.gz"
  sha256 "e8fe50d0f79ec3243733f8b4c25099c88b2597ed1bb0d94a27c4385a2a24ecac"

  bottle do
    sha256 "feea9c352fd19ca9d625a4b64458a7b7cedd3d027e2c1065dfdede3f4cdd81e7" => :catalina
    sha256 "832c27a3418c241ec128f93ccb395c21a53de85942bacf91eb110456500c9294" => :mojave
    sha256 "79f4d2e9a49be6044dde80c90b7ebb0cb781b86ece50bfb2cdab11c401b70244" => :high_sierra
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-GNinja", "-DNNG_ENABLE_DOC=ON", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    bind = "tcp://127.0.0.1:8000"

    pid = fork do
      exec "#{bin}/nngcat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    begin
      output = shell_output("#{bin}/nngcat --req --connect #{bind} --format ascii --data brew")
      assert_match(/home/, output)
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
