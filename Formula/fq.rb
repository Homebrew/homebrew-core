class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.9.7.tar.gz"
  sha256 "083d164bc11c6f8a0ba2fdb0dfec388fc338d0cea1351450de0955ec6f2d1576"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "f4acd389e1faf6ce4a0cbe888247d224db40b323e527cd9ba1da4701902df2b3" => :sierra
    sha256 "6410b083f57418900d1a1367d8659bb3f209a9a5b1f49c3ca6fb811148b6ee1d" => :el_capitan
    sha256 "9d21be29f644c2e535eba30edc2932e5ec94f4df34a77706f4d0bd9fec195837" => :yosemite
    sha256 "3a497a435d786efb52edf479bf47df3fba1ef16eb2fd3d7b7934cf74b676fb07" => :mavericks
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
