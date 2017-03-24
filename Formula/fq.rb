class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.10.4.tar.gz"
  sha256 "3ca0e6946501a41a52003804fae27e7d93e577ea36eef1bb0a9c5dc2c05ef171"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "bf903cd36fa604465e933ef37b9070d7657aff68f736b422c5eef1e25040bd30" => :sierra
    sha256 "8181f0905abfde2a55b9f6badacea4415190cf79a3be0e1d4d9be153832046a6" => :el_capitan
    sha256 "6159544b4d6fabddb8ae905df3c7d15285bd574915e0cf5ad4bd1600b7cee34b" => :yosemite
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
