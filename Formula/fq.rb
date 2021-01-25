class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.13.5.tar.gz"
  sha256 "a882059d66334ea84e23a7b86f2ec9e1daeb14e1b7253ab080c13c09e1716dd8"
  license "MIT"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "57f2a5e22f9f7d6712cfde3f6339d3487460d795086b6d09f67a01f68dd75fe2" => :big_sur
    sha256 "1da3d575b5ef3350c1410e90ba924b79455fa98adf8a637d189041aabdb136a0" => :catalina
    sha256 "fd3170bfa075df77cf33297020fee3b9cbf91f6069f3b3d9ff828af195ec64fb" => :mojave
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
