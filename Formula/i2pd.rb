class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.26.0.tar.gz"
  sha256 "2ae18978c8796bb6b45bc8cfe4e1f25377e0cfc9fcf9f46054b09dc3384eef63"

  bottle do
    cellar :any
    sha256 "05777cb3f61fdb348a0e4e83af0550721994d31ac67255c9fb940651d074881c" => :mojave
    sha256 "484982a69dd10251ed669e6e6d896240d890b3138e23550e872ef1fdf427fcd1" => :high_sierra
    sha256 "a40b82bfd60d267dbdd2e0be1a3704bdf3cfba492f0af3fa5a6a28386ba62a8e" => :sierra
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
