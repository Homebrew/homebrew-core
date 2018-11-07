class Nanomsg < Formula
  desc "Socket library in C"
  homepage "https://nanomsg.org/"
  url "https://github.com/nanomsg/nanomsg/archive/1.1.5.tar.gz"
  sha256 "218b31ae1534ab897cb5c419973603de9ca1a5f54df2e724ab4a188eb416df5a"
  head "https://github.com/nanomsg/nanomsg.git"

  bottle do
    sha256 "5c2c3457f3b318ef7428da07be20a971bd1f1d9a4938dd5bf99f2dc8cc0f5e0f" => :mojave
    sha256 "308f97b5316cb5bc01ba78746518cde9bca7d191d4ca3612b0670d5d10a480ef" => :high_sierra
    sha256 "6f34a93c9fbb60f3b7c9b18e353934b5ae17c7234975e1d3a55800a79b55bf70" => :sierra
    sha256 "e9726200950742bfe0eab4e2a6275d9c8c64c864f9acc15920f4f6616486e572" => :el_capitan
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
