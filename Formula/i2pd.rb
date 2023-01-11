class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.45.1.tar.gz"
  sha256 "a84b1e3cb5ac45f39af98e63291d34725ef67337e11acbe0e245acde7a5b2b72"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4d3f4b4869353a147ddb8c4554c5240b88cd61ebc6932b6c3fbcead5f9178a44"
    sha256 cellar: :any,                 arm64_monterey: "cd22e4402f4b7b33bc03b867d793d704451bfd8e268d09e07e5a38b2f3c32e1c"
    sha256 cellar: :any,                 arm64_big_sur:  "dd2eb77b57ba676e7d30baa4c8b79264edf687eda45f50543fe77e8bdf6b00ee"
    sha256 cellar: :any,                 ventura:        "0906a98472292ef57a343efb6e3d26abdc1409b1d2bf9567a7f2cf0a88877e11"
    sha256 cellar: :any,                 monterey:       "2f47bf121df1a3fa0d67837d88bedf51c37e9967d90fea7e746b03f3ee72df70"
    sha256 cellar: :any,                 big_sur:        "bfd5bed32d70bceb1afff17d8dc49feb1ab7136943ac9ee31d4a8891a3a1de0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2d296f95983dac3e4610a565d2054be6caf4830b1c062361a3555dce34bf15c"
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
