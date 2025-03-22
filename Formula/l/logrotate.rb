class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://github.com/logrotate/logrotate"
  url "https://github.com/logrotate/logrotate/releases/download/3.22.0/logrotate-3.22.0.tar.xz"
  sha256 "42b4080ee99c9fb6a7d12d8e787637d057a635194e25971997eebbe8d5e57618"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "90ddfc2708f68326d05446c86b053187949aeaa8c3ed5463e7e827018a9ada51"
    sha256 cellar: :any,                 arm64_sonoma:  "0439009653f0b4d9a2c3e0d298e4ffd2f784757c4f185dd6e6b87e0afe3e35d0"
    sha256 cellar: :any,                 arm64_ventura: "9526d7d94fbbf4d77d45a5b1c9b997c1f9a837479ed26e19e0dace4ef8fe0f8b"
    sha256 cellar: :any,                 sonoma:        "0cd0fdec8b7db339f1b64a71581284c69473956763a0cae5fcd7f79ae8d488fb"
    sha256 cellar: :any,                 ventura:       "631dce1810fd6010e337ad777501f7806f607083069d2bb493b17f9fa760a073"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c047f99df0fdd830943259ac9e82e6313e759b9e6bd9305dd838424c594861f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcd529f16cb51591df2b5697669cba2847f8230dda31a92a36718479a78c7913"
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
  end

  def post_install
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
    system "#{sbin}/logrotate", "-s", "logstatus", "testlogrotate.conf"
    assert(File.size?("test.log").nil?, "File is not zero length!")
  end
end
