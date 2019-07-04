class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.27.0.tar.gz"
  sha256 "46aa20760c85e3c5bf79229cd86b75a4c7e163271d400d0f104913d64cb8e093"

  bottle do
    cellar :any
    sha256 "4f957cdb584fecc7bf784907e3d1fda748b3f569ebb27dccd7ef0fa05e94338f" => :mojave
    sha256 "2af6275111a01bef1222752e19da18afc7228970341327e3011b10d33d324a43" => :high_sierra
    sha256 "3b4dd22e69bf5a702dc5f64c79dfa1e1f7b59f4a9f84a76cd847b5c5f25676f6" => :sierra
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@1.1"

  def install
    system "make", "install", "DEBUG=no", "HOMEBREW=1", "USE_UPNP=yes", "USE_AENSI=no", "USE_AVX=no", "PREFIX=#{prefix}"

    # preinstall to prevent overwriting changed by user configs
    confdir = etc/"i2pd"
    rm_rf prefix/"etc"
    confdir.install doc/"i2pd.conf", doc/"subscriptions.txt", doc/"tunnels.conf"
  end

  def post_install
    # i2pd uses datadir from variable below. If that path not exists, create that directory and create symlinks to certificates and configs.
    # Certificates can be updated between releases, so we must re-create symlinks to latest version of it on upgrade.
    datadir = var/"lib/i2pd"
    if datadir.exist?
      rm datadir/"certificates"
      datadir.install_symlink pkgshare/"certificates"
    else
      datadir.dirname.mkpath
      datadir.install_symlink pkgshare/"certificates", etc/"i2pd/i2pd.conf", etc/"i2pd/subscriptions.txt", etc/"i2pd/tunnels.conf"
    end

    (var/"log/i2pd").mkpath
  end

  plist_options :manual => "i2pd"

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
