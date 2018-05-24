class Nanomsg < Formula
  desc "Socket library in C"
  homepage "http://nanomsg.org"
  url "https://github.com/nanomsg/nanomsg/archive/1.1.3.tar.gz"
  sha256 "a25b7da0a3596fa45f4102b15c4329801711cceba2a530eeaff41189a46b6329"
  head "https://github.com/nanomsg/nanomsg.git"

  bottle do
    sha256 "dd584d9e1a3a2ed69a36f9db5cfb6aa0a25c57492fce5dc0f9c4881acc922583" => :high_sierra
    sha256 "123358e13bb19279f98efc1409662d7243ddd3cbda09dd2d6e1537fb15f61d33" => :sierra
    sha256 "0e8011a28082c5ecd421d614ec9cad8288fc5362ce605fd20231579a6073c7f0" => :el_capitan
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
