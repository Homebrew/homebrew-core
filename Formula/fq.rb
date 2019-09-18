class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.12.0.tar.gz"
  sha256 "3055ab146328c6d2882f3ce5c1e5de592e0b05f77bc09feb3e687ac26f1840a5"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "de903e4f96819780c272902e97e06fa91638746f74a0cca4ac412eead49d0d90" => :mojave
    sha256 "07321dacbe8386f547c8f7bee1ddcd9551d44268bf77688a1ef353c0c4b5bc87" => :high_sierra
    sha256 "3c37408415b375b759652ea84f8485f010bbeb84ea84fe4c81c8303b7785e647" => :sierra
  end

  depends_on "concurrencykit"
  depends_on "jlog"
  depends_on "openssl@1.1"

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
