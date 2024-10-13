class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/refs/tags/v0.13.11.tar.gz"
  sha256 "bd48eaed12d93b2f746df6c5f2f6ddc29902a4629acd2ce67d4e63c15235dd88"
  license "MIT"
  head "https://github.com/circonus-labs/fq.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "ebbcafa35c017138431466ac80be2e0cc9fe4f08ec82f72776b9d7ade31d34da"
    sha256 arm64_sonoma:   "90e55635d4ede2f18a7f05068675f4c841ff19847ed55c8727a5756dcf7a4fc6"
    sha256 arm64_ventura:  "108cf65a18d86c600cf71269b5f1d76c5068aca9f1ad648c898a93df43f0411c"
    sha256 arm64_monterey: "78bbc079ebb51b8a40faee45b9937e0dfac8b715f0df3da5639110441963f73d"
    sha256 sonoma:         "8c8ead0f9aa5354e763ae5e87b9ad32c1e55274abcc0e554c15ed3d1428c3df2"
    sha256 ventura:        "37ea5d45cb526690d3003297c5efb59cd7040b68a4270abe4a28a11771cd3277"
    sha256 monterey:       "be4eb1042b9c5dbdb9eeac614eedd8246afbe60d490d68b6de2a1da0f8921fb8"
    sha256 x86_64_linux:   "345283197d4a3cef92779527209392574f5f9bb8038ef0622769364eef6874b4"
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
