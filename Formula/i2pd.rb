class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.39.0.tar.gz"
  sha256 "3ffeb614cec826e13b50e8306177018ecb8d873668dfe66aadc733ca9fcaa568"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "be899cbd6346e27aa0d30ceebc5a7e198409f7050351b2f4217811904390303e"
    sha256 cellar: :any, arm64_big_sur:  "9e13462dfd0f3cd5e6afc79979ed48c6b09a243c3c5242b399c7dee418a3e1eb"
    sha256 cellar: :any, monterey:       "e8e8a23a976418e00c3a27026e980f717b3e5ca2c09af94acd3f4cc591a5ab6a"
    sha256 cellar: :any, big_sur:        "e2c0afab1198c4bcdde3dd1e6559ddcb868b2e192bf0dc8cdec9c336ddfc9baa"
    sha256 cellar: :any, catalina:       "4d3df93923c0489b44ca55cb3f7071962bd530ba73d778457cc9ae9d1602ba85"
    sha256 cellar: :any, mojave:         "eab780040dd0391df1af3aed028ed140ab126b2f272caea80aed15bda675b36b"
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@1.1"

  def install
    args = %W[
      DEBUG=no
      HOMEBREW=1
      USE_UPNP=yes
      PREFIX=#{prefix}
    ]

    args << "USE_AESNI=no" if Hardware::CPU.arm?

    system "make", "install", *args

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

  service do
    run [opt_bin/"i2pd", "--datadir=#{var}/lib/i2pd", "--conf=#{etc}/i2pd/i2pd.conf",
         "--tunconf=#{etc}/i2pd/tunnels.conf", "--log=file", "--logfile=#{var}/log/i2pd/i2pd.log",
         "--pidfile=#{var}/run/i2pd.pid"]
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
