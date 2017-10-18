class Nanomsg < Formula
  desc "Socket library in C"
  homepage "http://nanomsg.org"
  url "https://github.com/nanomsg/nanomsg/archive/1.1.0.tar.gz"
  sha256 "e81b79e073f5388a5070623136c7896244f8bbc24fd5f5255da8d5aa2e2a50e3"
  head "https://github.com/nanomsg/nanomsg.git"

  bottle do
    cellar :any
    sha256 "45c5998dec7d19819b77cdb74671b55eb5c3ebaf8e785ce7582baf90a0f44dc8" => :high_sierra
    sha256 "6dc4ea79f3c05afd0e28c4323905ca3611e1cfd633de74d9e9d65f61bb3fd8d1" => :sierra
    sha256 "fb85b321fc5d554c0bfd7b31c53dd7e6496ff5ad6dd94111298f23f45c6b5559" => :el_capitan
    sha256 "255ec0f726980ca16320ec1795e81ce275d8da730c5034e16c1134981d044522" => :yosemite
    sha256 "d3acb38b0fba0c1d78252471cb9ec63d6bbf82cdfbe0a3a125e3a6fc311ed57e" => :mavericks
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
