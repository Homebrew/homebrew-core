class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.10.11.tar.gz"
  sha256 "620bd9b056e5a513a74ad6f2e913534a865a4d9d6a8cc51278a34aceac407417"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "873769e9344e3d0af8bb871ba80f779bc99b966233d87859391a8f26b2363f91" => :high_sierra
    sha256 "85a4950aa2863975ca83a54ad494929f76b7cb843fcef23ddd3da322815b4467" => :sierra
    sha256 "bbf13f7165116c6424b97ba75a7fc8d905c01fc4d860ffa40c5fdf604105825d" => :el_capitan
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
