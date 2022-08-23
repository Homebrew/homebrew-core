class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.43.0.tar.gz"
  sha256 "db1679653491a411dd16fa329488d840296c8f680e0691f9fe0d0e796e5d7bca"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9f7800b89ff5c1aabd77d70469644c35d0f88b3c1f94ce80756afa42743c40d5"
    sha256 cellar: :any,                 arm64_big_sur:  "219e4dd3f3413c8dbe7e84aae283d01f926a0349beaf017ad997b7e0fb25df40"
    sha256 cellar: :any,                 monterey:       "a9c42df467116aecab5accdeb390633d638e8277461e71a58f8ae47cad56c9f5"
    sha256 cellar: :any,                 big_sur:        "8409e6c6f2894746d6b86187c0dbd8b74126cabe65319ec45a00a745b96187a4"
    sha256 cellar: :any,                 catalina:       "096a3b46f7eab0b883fa54ec184b427d1f50d15491b1097b78e189014af983d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1c6ee762c2c05261bd4a1efe7962b5424974b22e79d69c1fa0aa0e61a3b9a89"
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
