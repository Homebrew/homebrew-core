class Nanomsg < Formula
  desc "Socket library in C"
  homepage "http://nanomsg.org"
  url "https://github.com/nanomsg/nanomsg/archive/1.1.0.tar.gz"
  sha256 "e81b79e073f5388a5070623136c7896244f8bbc24fd5f5255da8d5aa2e2a50e3"
  head "https://github.com/nanomsg/nanomsg.git"

  bottle do
    sha256 "9d2f717a002b9525f7da3c501990132d649cc82e4010a0a1411a602802c10380" => :high_sierra
    sha256 "aa36e77ee27a492b5d995fb83b0c9b0b505c4fa5d4849cff51fb704309d40fb3" => :sierra
    sha256 "e64e92e97f269381d4b1b58e7f8e5be5718beab1823b08bc1f847e8188f9b42c" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    bind = "tcp://127.0.0.1:8000"

    pid = fork do
      exec "#{bin}/nanocat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    begin
      output = shell_output("#{bin}/nanocat --req --connect #{bind} --format ascii --data brew")
      assert_match /home/, output
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
