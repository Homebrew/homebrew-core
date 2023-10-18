class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.13.10.tar.gz"
  sha256 "fe304987145ec7ce0103a3d06a75ead38ad68044c0f609ad0bcc20c06cbfd62e"
  license "MIT"
  head "https://github.com/circonus-labs/fq.git", branch: "master"

  bottle do
    rebuild 1
    sha256 sonoma:       "eb9b15284089358379211dacdf2ce810d92c27f9a344a3acff7768dc15ef7110"
    sha256 ventura:      "f0e6202567699912b509c9ec544c9b193eb86001879e8fe3d4f449e02f3f5a4b"
    sha256 monterey:     "60be8da7fc7c0e9909d92c225815e220c697e498f1b62b4206d1bf2a72b58be1"
    sha256 big_sur:      "0953c716b652e678dd83c6aadc9b42b5d2699c1d9ed234e4387a3bbaad4f09ad"
    sha256 x86_64_linux: "e451023b35a528f0839e7e432ee2825ce4cc8deac929641da92242cd2e723128"
  end

  depends_on "concurrencykit"
  depends_on "jlog"

  uses_from_macos "sqlite"

  on_linux do
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
