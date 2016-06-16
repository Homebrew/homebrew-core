class Nanomsg < Formula
  desc "Socket library in C"
  homepage "http://nanomsg.org"
  url "https://github.com/nanomsg/nanomsg/archive/1.0.0.tar.gz"
  sha256 "24afdeb71b2e362e8a003a7ecc906e1b84fd9f56ce15ec567481d1bb33132cc7"
  head "https://github.com/nanomsg/nanomsg.git"

  bottle do
    cellar :any
    sha256 "a4ce042732d7112efac1f35c654f748615396b7f8defecfb55c3ac5c3ad2bcb6" => :el_capitan
    sha256 "68c2434b5da8880dd93f5bc6c6a58cf9a6a6315dcdc5d8a8d9586fe1cd35c6b4" => :yosemite
    sha256 "252a364dc0d5da396e3b3c194e502bace71b670cdbc3a073216255ee3d1fab12" => :mavericks
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
