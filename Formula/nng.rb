class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/v1.3.0.tar.gz"
  sha256 "e8fe50d0f79ec3243733f8b4c25099c88b2597ed1bb0d94a27c4385a2a24ecac"

  bottle do
    sha256 "563fbcedf8519b6fa5c3c328065d068f5f76174030ad8afbb0e499490585300e" => :catalina
    sha256 "170e88bbd66c2692f665c7e2ec03d6287a0ac5a1d61a4cd40452b2e9d7c78375" => :mojave
    sha256 "418d463185fef90d0952b7b773c12eae587b75b0438d9154d0cc1564f242465d" => :high_sierra
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
