class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.10.14.tar.gz"
  sha256 "4ca905a30ff8d6f93fe444058fb5b342e06a083ff9dd4b827a1fc9eb112e039c"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "25885b6f1939bb966519a4f1c7347e47612fb4913179444d0d0942216a0aff53" => :mojave
    sha256 "0e070a7f846a052fd753d5d40d53e24e6591cea1515999f74103043ff92d8df7" => :high_sierra
    sha256 "ae4e13c72c53b3c46f71d312ed89cc84571c60dcaa943758ffa4373e2c2d2a95" => :sierra
    sha256 "0abc3a43e557ec72656618ebb33cf7377de6a282a299278ceb9df339bb430908" => :el_capitan
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
