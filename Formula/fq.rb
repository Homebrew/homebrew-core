class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.12.0.tar.gz"
  sha256 "3055ab146328c6d2882f3ce5c1e5de592e0b05f77bc09feb3e687ac26f1840a5"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "1416630a8b706eef3660396cc12560c4ef15e1010cc95b4aaacea4106b114e2b" => :mojave
    sha256 "98135cb0b96af80606046f54f103ebdca60baf9e3379b120c1cca07aa604322f" => :high_sierra
    sha256 "8c6527e326a7477574c5321800895a64fb3753bdfb57f14ebb9f9ebb652803ae" => :sierra
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
