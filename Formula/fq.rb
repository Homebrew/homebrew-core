class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.13.5.tar.gz"
  sha256 "a882059d66334ea84e23a7b86f2ec9e1daeb14e1b7253ab080c13c09e1716dd8"
  license "MIT"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "526f8bd3827c657b68e255548af318404f488dbb52e270b68aa4035579094edc" => :big_sur
    sha256 "2bfae7445286bb2cac9ccde216c00d4bab996da613621b4a6332a0c39463d900" => :catalina
    sha256 "a2f5a81b57c0c701a95fde6a328d4ade2111d79a1d674b9afb4bf02acf6a9c25" => :mojave
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
