class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.10.9.tar.gz"
  sha256 "ce0f62738fe387371c7c40174dc2c4398a0c0493fc611eda6aae0da96c2ac4ba"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "92652cbe71c96ebed9d9b8c61e56b826d7ebc42d5fb8f2064309b85603332c0d" => :high_sierra
    sha256 "b0e4d4c4906e472661bf7b521cfa0543034bec859aa3abbb81851abefea877ac" => :sierra
    sha256 "f77b781f1f47787dd3dfd2d5123a216058783432d25e110a61ee45f6657ec05e" => :el_capitan
  end

  depends_on "concurrencykit"
  depends_on "jlog"
  depends_on "openssl"

  def install
    inreplace "Makefile", "/usr/lib/dtrace", "#{lib}/dtrace"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
    bin.install "fqc", "fq_sndr", "fq_rcvr"
  end

  test do
    pid = fork { exec sbin/"fqd", "-D", "-c", testpath/"test.sqlite" }
    sleep 1
    begin
      assert_match /Circonus Fq Operational Dashboard/, shell_output("curl 127.0.0.1:8765")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
