class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.10.4.tar.gz"
  sha256 "3ca0e6946501a41a52003804fae27e7d93e577ea36eef1bb0a9c5dc2c05ef171"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "475b21e05f3fbd50939efda0d6d3dfd56ff5777f9b4596f9fb6a1319dd7afa55" => :sierra
    sha256 "0ea2989cdd26147d34fe4c17facfcc74845d51565912f25621defa32eda03020" => :el_capitan
    sha256 "4f27968c980260296d83206ad006d8033335caaccdc3ac002d582466d2a8ebee" => :yosemite
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
