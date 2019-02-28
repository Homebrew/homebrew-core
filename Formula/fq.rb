class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.10.14.tar.gz"
  sha256 "4ca905a30ff8d6f93fe444058fb5b342e06a083ff9dd4b827a1fc9eb112e039c"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "6970fc5e6420741afa7e567f40d787c62a611700ac04f2f5f919e87a97dd52ed" => :mojave
    sha256 "bf5f30f4140c8738cf82c2df996a0e374f649a17b5eb12a82f5b405ca0a84ca1" => :high_sierra
    sha256 "b4915e960d6cca6c23a4a7de5de08083d827f78d7011542e2a76a8519f75c943" => :sierra
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
