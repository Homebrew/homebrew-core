class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.13.8.tar.gz"
  sha256 "efd6b7007e317ff562bf0c7abf1817db48153d9b8a1495fa4f025dec8c4c7de7"
  license "MIT"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 big_sur:  "7ebbd20f8d7fde7ae781e2ab430d3721d62e4536db6155b50dfb2467e849be66"
    sha256 catalina: "de8abe5779afcea66bb6365ee1f7a0a00dcec6ffcbfe12ab639442ca1421f875"
    sha256 mojave:   "5b5f533adb69d9750ba18722054685d01bcbd1e1860c9f3bb5daddad550384b8"
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
