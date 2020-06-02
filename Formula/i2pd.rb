class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.32.1.tar.gz"
  sha256 "64229101411a9dda3237dc27939aa13ec90d4900aae499e59931063c36e8556b"

  bottle do
    cellar :any
    sha256 "20a70b43019fff1b44574ccdcf063dc9ec1f124981ef440f9f4965876ccc91ed" => :catalina
    sha256 "3d969437dbcfd2478c9f9f7d15198b82688f2a4f7e8c5baf899cf222f295fa4d" => :mojave
    sha256 "7ac28062bb7630d5ccedbdbd87b529576b1d22c76e92c28a99ea9305316f24aa" => :high_sierra
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@1.1"

  def install
    system "make", "install", "DEBUG=no", "HOMEBREW=1", "USE_UPNP=yes",
                              "USE_AENSI=no", "USE_AVX=no", "PREFIX=#{prefix}"

    # preinstall to prevent overwriting changed by user configs
    confdir = etc/"i2pd"
    rm_rf prefix/"etc"
    confdir.install doc/"i2pd.conf", doc/"subscriptions.txt", doc/"tunnels.conf"
  end

  def post_install
    # i2pd uses datadir from variable below. If that path doesn't exist,
    # create the directory and create symlinks to certificates and configs.
    # Certificates can be updated between releases, so we must recreate symlinks
    # to the latest version on upgrade.
    datadir = var/"lib/i2pd"
    if datadir.exist?
      rm datadir/"certificates"
      datadir.install_symlink pkgshare/"certificates"
    else
      datadir.dirname.mkpath
      datadir.install_symlink pkgshare/"certificates", etc/"i2pd/i2pd.conf",
                              etc/"i2pd/subscriptions.txt", etc/"i2pd/tunnels.conf"
    end

    (var/"log/i2pd").mkpath
  end

  plist_options :manual => "i2pd"

  def plist
    <<~EOS
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
