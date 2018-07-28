class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website"
  url "https://github.com/PurpleI2P/i2pd/archive/2.19.0.tar.gz"
  sha256 "7202497ffc3db632d0f7fed93eafaf39aa75efea199705dae7d022249b069eb9"

  depends_on "make" => :build
  depends_on "boost"
  depends_on "libressl"
  depends_on "miniupnpc"

  needs :cxx11

  def install
    ENV["HOMEBREW_OPTFLAGS"] = "-march=#{Hardware.oldest_cpu}" unless build.bottle?

    system "make", "HOMEBREW=1", "USE_UPNP=yes"
    bin.install "i2pd"
    doc.install "README.md", "LICENSE", "ChangeLog"
    pkgshare.install "contrib/certificates"
    man1.install "debian/i2pd.1"
    (etc/"i2pd").install buildpath/"contrib/i2pd.conf", buildpath/"contrib/subscriptions.txt", buildpath/"contrib/tunnels.conf"
    (var/"lib/i2pd").install_symlink pkgshare/"certificates", etc/"i2pd/i2pd.conf", etc/"i2pd/subscriptions.txt", etc/"i2pd/tunnels.conf"
  end

  def post_install
    (var/"log/i2pd").mkpath
  end

  plist_options :startup => true, :manual => "i2pd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/i2pd</string>
        <string>--datadir=#{var}/lib/i2pd</string>
        <string>--conf=#{etc}/i2pd/i2pd.conf</string>
        <string>--tunconf=#{etc}/i2pd/tunnels.conf</string>
        <string>--log=file</string>
        <string>--logfile=#{var}/log/i2pd/i2pd.log</string>
        <string>--pidfile=#{var}/run/i2pd.pid</string>
      </array>
    </dict>
    </plist>
  EOS
  end

  test do
    pid = fork do
      exec "#{bin}/i2pd", "--datadir=#{testpath}", "--daemon"
    end
    sleep 5
    Process.kill "TERM", pid
    assert_predicate testpath/"router.keys", :exist?, "Failed to start i2pd"
  end
end
