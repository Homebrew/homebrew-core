class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.10.6.tar.gz"
  sha256 "75f2b6bb6359714ef30c81f37ae964302729400141591c830c28525c4de7d396"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "5f0a3d0263c80f8f623b201103cf4262213a21f355ace7037b02145a0d0d3242" => :sierra
    sha256 "cf379add9665e48776c6083ec15f8e7d7c0e2036a072d9a04dae109550eb7242" => :el_capitan
    sha256 "508d82d68e29891fbcc027761f9cdea6e157822460c8ba5bbcf8819b15679acb" => :yosemite
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
