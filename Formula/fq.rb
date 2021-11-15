class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.13.10.tar.gz"
  sha256 "fe304987145ec7ce0103a3d06a75ead38ad68044c0f609ad0bcc20c06cbfd62e"
  license "MIT"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 monterey: "08bdc96d9e8587b7cfa430fe6eebdc0bdaef042f8b2d0150309977c8fcd46fc0"
    sha256 big_sur:  "cc5d1afac284b9e5f0c94e46f02d66dae8bc5a6a49dda7b2c95c82b62c82bb9e"
    sha256 catalina: "67a46b7b2067466a653e64327ed90d2b0d5624b025df8919e1376710471ba7a7"
    sha256 mojave:   "195ecf7b14066822a6645469e43cf5550f825e6989531dffa43d66d029228743"
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
