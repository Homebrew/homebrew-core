class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.46.0.tar.gz"
  sha256 "daa5e47bb2b80fbdaa3836b209e869017893421f5225dfe019e5d43d3f8a86d4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a1e1de8afcff0aadfced7b841d975dd14b6bf5371c98545f322f1b79aa815fd3"
    sha256 cellar: :any,                 arm64_monterey: "5578063536a94dd167fbde5c94dcffd95e07796e6db5a534d4cb6f9b7d4e713b"
    sha256 cellar: :any,                 arm64_big_sur:  "9537d6fee40b0f17419fba3016f5cb22ed20454a0b197aa74bfa5fde44c30318"
    sha256 cellar: :any,                 ventura:        "fd232882710dafc63ec44b2de8ca8d65e08930a2b0ee5e22de07af5a972e668a"
    sha256 cellar: :any,                 monterey:       "ae5c2d7b63bc1bce31b7bd5fca4895e978e9e1303a1f62fec789addaa98db81e"
    sha256 cellar: :any,                 big_sur:        "e4c6108b75672108a01bda6a8d450a819f0823ae25c2d61bcc6e57e2573feebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbea0a7877c3ef1ecd9a741d68dd7c8f66ded490c66b70b69d717a84981a31dd"
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@3"

  def install
    args = %W[
      DEBUG=no
      HOMEBREW=1
      USE_UPNP=yes
      PREFIX=#{prefix}
      BREWROOT=#{HOMEBREW_PREFIX}
      SSLROOT=#{Formula["openssl@3"].opt_prefix}
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
