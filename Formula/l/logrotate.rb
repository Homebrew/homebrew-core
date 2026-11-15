class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://github.com/logrotate/logrotate"
  url "https://github.com/logrotate/logrotate/releases/download/3.22.0/logrotate-3.22.0.tar.xz"
  sha256 "42b4080ee99c9fb6a7d12d8e787637d057a635194e25971997eebbe8d5e57618"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_golden_gate: "e85b9ccac8c53bf7990ff6f3b7f569c8dad8736bbd7b81ff9f41cc47e8c330b0"
    sha256 cellar: :any, arm64_tahoe:       "78f780e907bf58fb974266ef98a7d5cf6707c89a3f3158132fa19e90755903eb"
    sha256 cellar: :any, arm64_sequoia:     "02751c8972565a8ac4700289e9216b2570d3cefda92d97594f884db068e491d8"
    sha256 cellar: :any, arm64_linux:       "cfa0e329b27481f9729ef8c5ad3c167f2c8161ca983986bf38b78b69228835c3"
    sha256 cellar: :any, x86_64_linux:      "d33b1855513d0931deb474fbf16e233e5bdc98cb056e617f53a787edb79939a3"
  end

  depends_on "popt"

  on_linux do
    depends_on "acl"
  end

  deny_network_access!

  def install
    system "./configure", "--with-compress-command=/usr/bin/gzip",
                          "--with-uncompress-command=/usr/bin/gunzip",
                          "--with-state-file-path=#{var}/lib/logrotate.status",
                          *std_configure_args
    system "make", "install"

    inreplace "examples/logrotate.conf", "/etc/logrotate.d", "#{etc}/logrotate.d"
    etc.install "examples/logrotate.conf"

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
