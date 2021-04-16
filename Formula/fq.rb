class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.13.9.tar.gz"
  sha256 "a6eb89d53209606bf355aa75d76a07e4b2340224bc1ecc90757ab916a404b458"
  license "MIT"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 big_sur:  "a5b7c5fedfc2cd4897f9d30e275944d2783978e4f11a8069c31ac48f8a19aebc"
    sha256 catalina: "5bb14e38f39edb68c4a6a2bb55e92b8fed9908806eac93fbc2f712c4315c92a7"
    sha256 mojave:   "16794e36dbe275b24f5413946573606b64d7b0ec764009336a690b8298ae5de5"
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
      assert_match "Circonus Fq Operational Dashboard", shell_output("curl 127.0.0.1:8765")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
