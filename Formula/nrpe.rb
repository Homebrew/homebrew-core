class Nrpe < Formula
  desc "Nagios remote plugin executor"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz"
  sha256 "66383b7d367de25ba031d37762d83e2b55de010c573009c6f58270b137131072"
  revision 1

  bottle do
    cellar :any
    rebuild 2
    sha256 "844c6dab823dabfd855bd9074120d5b7272381b0d26715b9386e8442dba5b91e" => :high_sierra
    sha256 "7f1020ec90004decbe2f902bbf3aa31cc994ee073da054c5aa3713f61b785a4d" => :sierra
    sha256 "a2af86f9a4eae43266f84f9cf62544657a2508272249a9f39a3dd62b06642b0c" => :el_capitan
    sha256 "7e5975244c0a97fc01bbd5aaabd73f768f7cc831bed026394b59e0d7ebf32cdf" => :yosemite
    sha256 "59df072ab20b615e4c26198be439796f4415816af5be7cd661a3d115d7f73705" => :mavericks
  end

  depends_on "nagios-plugins"
  depends_on "openssl"

  def install
    user  = `id -un`.chomp
    group = `id -gn`.chomp

    (var/"run").mkpath
    inreplace "sample-config/nrpe.cfg.in", "/var/run/nrpe.pid", var/"run/nrpe.pid"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--libexecdir=#{HOMEBREW_PREFIX}/sbin",
                          "--sysconfdir=#{etc}",
                          "--with-nrpe-user=#{user}",
                          "--with-nrpe-group=#{group}",
                          "--with-nagios-user=#{user}",
                          "--with-nagios-group=#{group}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          # Set both or it still looks for /usr/lib
                          "--with-ssl-lib=#{Formula["openssl"].opt_lib}",
                          "--enable-ssl",
                          "--enable-command-args"

    inreplace "src/Makefile", "$(LIBEXECDIR)", "$(SBINDIR)"

    system "make", "all"
    system "make", "install"
    system "make", "install-daemon-config"
  end

  plist_options :manual => "nrpe -n -c #{HOMEBREW_PREFIX}/etc/nrpe.cfg -d"

  def plist; <<~EOS
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
