class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/refs/tags/v0.13.12.tar.gz"
  sha256 "4329fa7678437c2d22f021ec8a5bed2b7a7eeb608bbfe4c8749f8520011b12d3"
  license "MIT"
  head "https://github.com/circonus-labs/fq.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "0ee4f40eee6d68ea8e39759b2bdb59036eb03863b435c0ca11d21243e2b3a26c"
    sha256 arm64_tahoe:       "af9f15d2ab89561c12e797f7e709e1b26e47cce0759823f5c6d0478a003b6198"
    sha256 arm64_sequoia:     "9bb54081fd33ccff3f7cbef0361a7cd1744ba09cbb67f41e779a1dda1b4cd251"
    sha256 arm64_linux:       "0d08e1ca55ac0b75b522c204cb0aca4bd0044e1f287088858bb84a6cfe9d04a9"
    sha256 x86_64_linux:      "2c21025a440f8167559fb2daf944f4fbc138b23a472aa0b4f792bc69e0bff46b"
  end

  depends_on "concurrencykit"
  depends_on "jlog"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "bind" => :test # for `dig`
    depends_on "openssl@4"
    depends_on "util-linux"
  end

  def install
    ENV.append_to_cflags "-DNO_BCD=1"
    inreplace "Makefile", "-lbcd", ""
    inreplace "Makefile", "/usr/lib/dtrace", "#{lib}/dtrace"
    system "make", "PREFIX=#{prefix}"
    args = ["PREFIX=#{prefix}"]
    args << "ENABLE_DTRACE=0" unless OS.mac?
    system "make", "install", *args
    bin.install "fqc", "fq_sndr", "fq_rcvr"
  end

  test do
    ipv4 = shell_output("dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com | tr -d '\"'").strip
    port = free_port
    pid = spawn sbin/"fqd", "-p", port.to_s, "-n", ipv4, "-D", "-c", testpath/"test.sqlite"
    begin
      output = shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}")
      assert_match "Circonus Fq Operational Dashboard", output
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
