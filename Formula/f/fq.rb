class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/refs/tags/v0.13.12.tar.gz"
  sha256 "4329fa7678437c2d22f021ec8a5bed2b7a7eeb608bbfe4c8749f8520011b12d3"
  license "MIT"
  head "https://github.com/circonus-labs/fq.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "319d0358ae90ea27c5159a4585fc403b3d7aad3e58a9b6d0f9b2cc5e336e4228"
    sha256 arm64_sequoia: "33e9232200183fa00074369edd7822c4bdd5b34eca4f0bf1e6f46536b99bdf22"
    sha256 arm64_sonoma:  "37327110567a05788dbae0310ac20b1c1790a1e1642117435ac900a013bfc5dd"
    sha256 arm64_ventura: "0c8d4409a94927f6f2a848bb04de94f78de2c1237bc84e0c798ab7cb66900663"
    sha256 sonoma:        "1d570f53f452d8ec4c4083cd66c8584afaef37ffa23127e048eeb11f8088885e"
    sha256 ventura:       "7dd8e45903e1180c2f88a33e7d7690c6e897084114b770d52fe1415183051452"
    sha256 arm64_linux:   "598374e01be91a1db12f92c5a04c4722ee287d11e44437628a99043a7f4a9c3c"
    sha256 x86_64_linux:  "2425df3421667d23f2734b087ca7c28707ece5604dc7b521313134e102865ba0"
  end

  depends_on "concurrencykit"
  depends_on "jlog"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "bind" => :test # for `dig`
    depends_on "openssl@3"
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
    pid = fork { exec sbin/"fqd", "-p", port.to_s, "-n", ipv4, "-D", "-c", testpath/"test.sqlite" }
    sleep 10
    begin
      assert_match "Circonus Fq Operational Dashboard", shell_output("curl 127.0.0.1:#{port}")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
