class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.40.0.tar.gz"
  sha256 "4443f484ad40753e892170a26c8ee8126e8338bf416d04eab0c55c1c94a4e193"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "cff84e998bb2781223a5384e944a3a28d6c693acbb28aef64319f1399a1bf4be"
    sha256 cellar: :any, arm64_big_sur:  "431bcc8bb585f504062092bcd0584880aa9ae89f41692d3e6c578c8694b64647"
    sha256 cellar: :any, monterey:       "bc8dba11ea436286889df672cbcdbb423d4d1038e6ae0938f18c76417cf7084b"
    sha256 cellar: :any, big_sur:        "77631a8ce2044e3e8c6c32a1ed3f9d6113f3a444d1a4ee40faad42a1ea854854"
    sha256 cellar: :any, catalina:       "c2c6fc26a6ea516e9b6c87ffc01a6f62da37fb5ad4bf083cab850baaefb98994"
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
    pidfile = testpath/"i2pd.pid"
    system bin/"i2pd", "--datadir=#{testpath}", "--pidfile=#{pidfile}", "--daemon"
    sleep 5
    assert_predicate testpath/"router.keys", :exist?, "Failed to start i2pd"
    pid = pidfile.read.chomp.to_i
    Process.kill "TERM", pid
  end
end
