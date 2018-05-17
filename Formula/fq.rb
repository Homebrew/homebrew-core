class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.10.11.tar.gz"
  sha256 "620bd9b056e5a513a74ad6f2e913534a865a4d9d6a8cc51278a34aceac407417"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "f3c055e79684d71db62dbc1ee77c31ef2008d6dc0bef3bfbb712eb78bb7f3ebf" => :high_sierra
    sha256 "45f97a6b9974bdf11dcc45f65602380f18c1c9da327e85cec40a951d448b356e" => :sierra
    sha256 "3653d5b46e6d484b0d53fb19556db680ab0849c7dd12f30fca0fd007c9edbef2" => :el_capitan
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
