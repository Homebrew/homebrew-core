class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.32.0.tar.gz"
  sha256 "a68bcc3585fb150bb3781a77ddab97d2618fe58dc004543a9dddb74518e22e58"

  bottle do
    cellar :any
    sha256 "a91e1a83f1ad4da78a9385b7f822edf6ce0cb0ddc521038f71eba44de7e3aebe" => :catalina
    sha256 "0a15abc72bce0f602fcdaee3fa6fee1f20f30e009561bc58acbbf4d4c347fef4" => :mojave
    sha256 "9304596e16fc65b4f49b2c9ec1e140056ae252e0d3deb975b327b6b174eb0dd8" => :high_sierra
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
