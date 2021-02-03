class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.13.7.tar.gz"
  sha256 "5ba5b06931e400965337c80246fd460b14add8214277fb5724c372b60aa5a8e0"
  license "MIT"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 big_sur: "43fbc72078e9932a6a4e6a7366672e8bc125ba8141a0819282c1c25177279aeb"
    sha256 catalina: "c40fe71ff341f6143ecbc0a8d8da289965b2c045359fb878975e432e0027d374"
    sha256 mojave: "914c62b4e0a5cf235cb770d9de8ea409e66941801afa5fc511c6654333b1b004"
  end

  depends_on "concurrencykit"
  depends_on "jlog"
  depends_on "openssl@1.1"

  def install
    ENV.append_to_cflags "-DNO_BCD=1"
    inreplace "Makefile", "-lbcd", ""
    inreplace "Makefile", "/usr/lib/dtrace", "#{lib}/dtrace"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
    bin.install "fqc", "fq_sndr", "fq_rcvr"
  end

  test do
    pid = fork { exec sbin/"fqd", "-D", "-c", testpath/"test.sqlite" }
    sleep 10
    begin
      assert_match /Circonus Fq Operational Dashboard/, shell_output("curl 127.0.0.1:8765")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
