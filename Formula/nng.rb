class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/v1.2.5.tar.gz"
  sha256 "bcf59c43fde9a7fc84fd214d6db41e719705bb12e300a89e0e161139a39b7527"

  bottle do
    sha256 "c3a7e04ff678c74dee787be177b169455418e57de882a7de819b9c52ea8033e5" => :catalina
    sha256 "61000ae2d8e4a570a8eb0af4411b5f1f601891d50bfdd4e315db72aef08a8f23" => :mojave
    sha256 "10e973ad80757129bd62d9e4b25e93793ad059314b2a6605dbcf453971b94e25" => :high_sierra
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
