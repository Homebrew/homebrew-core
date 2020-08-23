class Nrpe < Formula
  desc "Nagios remote plugin executor"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nrpe-4.x/nrpe-4.0.3/nrpe-4.0.3.tar.gz"
  sha256 "f907ba15381adfc6eef211508abd027f8e1973116080faa4534a1191211c0340"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "6ef7387202f3b9afda335fd77f16a268a82bed7a9f6ef856faa83741b308d8f2" => :catalina
    sha256 "90463f41b64e1ac2149dd917d536e406ed22ba9cef8a27e06618bab53c4e673e" => :mojave
    sha256 "e109e63ca7f6f5386eae058d19e510c5d3a5deb2633f8ef014df1ac24d414cb9" => :high_sierra
  end

  depends_on "nagios-plugins"
  depends_on "openssl@1.1"

  def install
    user  = `id -un`.chomp
    group = `id -gn`.chomp

    system "./configure", "--prefix=#{prefix}",
                          "--libexecdir=#{HOMEBREW_PREFIX}/sbin",
                          "--with-piddir=#{var}/run",
                          "--sysconfdir=#{etc}",
                          "--with-nrpe-user=#{user}",
                          "--with-nrpe-group=#{group}",
                          "--with-nagios-user=#{user}",
                          "--with-nagios-group=#{group}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          # Set both or it still looks for /usr/lib
                          "--with-ssl-lib=#{Formula["openssl@1.1"].opt_lib}",
                          "--enable-ssl",
                          "--enable-command-args"

    inreplace "src/Makefile" do |s|
      s.gsub! "$(LIBEXECDIR)", "$(SBINDIR)"
      s.gsub! "$(DESTDIR)/usr/local/sbin", "$(SBINDIR)"
    end

    system "make", "all"
    system "make", "install", "install-config"
  end

  def post_install
    (var/"run").mkpath
  end

  plist_options manual: "nrpe -n -c #{HOMEBREW_PREFIX}/etc/nrpe.cfg -d"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>org.nrpe.agent</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/nrpe</string>
          <string>-c</string>
          <string>#{etc}/nrpe.cfg</string>
          <string>-d</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>ServiceDescription</key>
        <string>Homebrew NRPE Agent</string>
        <key>Debug</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/nrpe", "-n", "-c", "#{etc}/nrpe.cfg", "-d"
    end
    sleep 2

    begin
      output = shell_output("netstat -an")
      assert_match /.*\*\.5666.*LISTEN/, output, "nrpe did not start"
      pid_nrpe = shell_output("pgrep nrpe").to_i
    ensure
      Process.kill("SIGINT", pid_nrpe)
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
