class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.13.8.tar.gz"
  sha256 "efd6b7007e317ff562bf0c7abf1817db48153d9b8a1495fa4f025dec8c4c7de7"
  license "MIT"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 big_sur:  "677a5f40a54236cefcbc1af22e8a123d6d88bee557317be13a3666448166cc5e"
    sha256 catalina: "020ef39debe9c24af6d6486ffe47505e9753852b9ef266ca33fd78ad1db1f58d"
    sha256 mojave:   "e58b421e6540cc2bc3a4dec3059da649514aa3aabc10546d75055fe6a9ef32bf"
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
      assert_match /Circonus Fq Operational Dashboard/, shell_output("curl 127.0.0.1:8765")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
