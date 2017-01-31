class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.10.0.tar.gz"
  sha256 "8a263e29d0f497ea63da214269943c6411b399076b85e707218d0530ec331a03"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "d30a7a8b1a5b95843cba552c8c303ef71d9c329407bb378abebf18eafc985492" => :sierra
    sha256 "08c67e78b014cc659f4fc723b714fbe2219b8e53205d3bcd361babad6ebacaad" => :el_capitan
    sha256 "72416f356d3d79179efc939f0fdff4a32c7f50f80f3adb6e72bc08eabad39525" => :yosemite
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
