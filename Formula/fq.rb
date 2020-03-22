class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.13.0.tar.gz"
  sha256 "01fb729a0a2257c944e6489718ce6d334f3dd3639cb8d604592c291d1bd017ea"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "cca321d03043680c3e666e064a22ea8dc68ee65e239160393356f96713b48c47" => :catalina
    sha256 "d0b2de2159e496bbe939ad72a64ce637551787cb44a4e822372e33c049ee3f6f" => :mojave
    sha256 "58c430bd24667e0209009d9b3aae0c1fc07e857dc16ec5f19c9b568afeba0d68" => :high_sierra
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
