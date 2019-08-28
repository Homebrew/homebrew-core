class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.11.0.tar.gz"
  sha256 "cdfb490cfa6ae5f526203a966228a85a9cc7d9c1698cf45fdf17718d8a765122"
  revision 1
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "35f644c9d13c56248a1f2d6edc8fed00d7282648793aa51108e6c98728874cad" => :mojave
    sha256 "7d456eec116cebaa3c6357b047d8c853d64d2441ba267790cad476ca6dd15dae" => :high_sierra
    sha256 "2a9fab74e2470c21a17812dfca5015d5ee34a5519427a96ec96db8bec3c5d818" => :sierra
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
