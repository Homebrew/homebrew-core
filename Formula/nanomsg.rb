class Nanomsg < Formula
  desc "Socket library in C"
  homepage "http://nanomsg.org"
  url "https://github.com/nanomsg/nanomsg/archive/1.1.4.tar.gz"
  sha256 "ae5c688e874bf9bf1db764d08538c54f6ce9e4dc78bc5948008a304d519ad3b6"
  head "https://github.com/nanomsg/nanomsg.git"

  bottle do
    sha256 "8ceda3b872e13d64a581f8bfb8d3483b7d76e14dd68a1ddce8e242b92e812c66" => :high_sierra
    sha256 "2125e5aa5d10bbbd398875a7d0fb8376616a21d0145c81a3c1350fde8d3f883d" => :sierra
    sha256 "a2517838eacb51763aeccc38671e52a0feb27fc0d3a312fdc1ec7d1530b50a12" => :el_capitan
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
