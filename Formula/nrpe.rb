class Nrpe < Formula
  desc "Nagios remote plugin executor"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nrpe-4.x/nrpe-4.0.0.tar.gz"
  sha256 "a3d0a7ac5385421dfcc29afce7eeade13ca10d8d9115ca5c2962b72946c88a1e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7c0ce6b92d5fe437be7c96a45aa59e5497bfaf9dd29de04128a137afdd86e90b" => :catalina
    sha256 "d68901dd62599886b0221f60672cef58f18a6d1dc39c28ac8eb955f90e80daf1" => :mojave
    sha256 "1338535bd58f188ed452b40bdc6b38c0b45ed56cb39819293c2d896031114659" => :high_sierra
    sha256 "5ec433eb1047741db64c0e16a8c216ffce9764ab45a7b5bf881bbb2f7e7a98d1" => :sierra
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
