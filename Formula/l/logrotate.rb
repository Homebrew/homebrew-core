class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://github.com/logrotate/logrotate"
  url "https://github.com/logrotate/logrotate/releases/download/3.22.0/logrotate-3.22.0.tar.xz"
  sha256 "42b4080ee99c9fb6a7d12d8e787637d057a635194e25971997eebbe8d5e57618"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "956be5c37ef380ddac0212fb5016e5d4a6baaefb6abe55d081eb8d130e3c8790"
    sha256 cellar: :any,                 arm64_sequoia: "f23f3fac084d295e4c386d0e0a2a95af2b54adfb732aed1549f2ecf7fb1738e2"
    sha256 cellar: :any,                 arm64_sonoma:  "29629b2a739cf74d95eaf260872024ffeaf7b194f461d74d20cd07afa4d7361b"
    sha256 cellar: :any,                 sonoma:        "83bb9be87509907cbb33a7ae78a4ff40ac00ac9da01f99d85817d2391cb2439f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a65380b56872b8ac8acbedc3400a24c32b278b2e241f631bbeb88e7b485b1b0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d507205d500b30fedd4f60fccb2e4667985bfaf9348b26b641ff357ce89a442b"
  end

  depends_on "popt"

  def install
    system "./configure", "--with-compress-command=/usr/bin/gzip",
                          "--with-uncompress-command=/usr/bin/gunzip",
                          "--with-state-file-path=#{var}/lib/logrotate.status",
                          *std_configure_args
    system "make", "install"

    inreplace "examples/logrotate.conf", "/etc/logrotate.d", "#{etc}/logrotate.d"
    etc.install "examples/logrotate.conf" => "logrotate.conf"

    (etc/"logrotate.d").mkpath
    (var/"lib").mkpath
  end

  service do
    run [opt_sbin/"logrotate", etc/"logrotate.conf"]
    run_type :cron
    cron "25 6 * * *"
  end

  test do
    (testpath/"test.log").write("testlograndomstring")
    (testpath/"testlogrotate.conf").write <<~EOS
      #{testpath}/test.log {
        size 1
        copytruncate
      }
    EOS
    system sbin/"logrotate", "-s", "logstatus", "testlogrotate.conf"
    assert_predicate testpath/"test.log", :zero?
  end
end
