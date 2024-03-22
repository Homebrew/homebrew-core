class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.50.2.tar.gz"
  sha256 "ae2ec4732c38fda71b4b48ce83624dd8b2e05083f2c94a03d20cafb616f63ca5"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9aed2654ae1637f7fbad14d15934b0b2d6b493754757b8e23fe874b41e3a5e54"
    sha256 cellar: :any,                 arm64_ventura:  "12ae507e36270f6a462438ed280fcd9d80a307960c4c60757f5d6f0cdc54cc42"
    sha256 cellar: :any,                 arm64_monterey: "cec83c1cbbf0b254aefb3144b2149de2bba4350b9ab52faea5902a5dfac3c730"
    sha256 cellar: :any,                 sonoma:         "cf42a80b575916054c67944a595af7c5d3b12485aa157acb955ee41c070735bf"
    sha256 cellar: :any,                 ventura:        "5f3c01c424667d5a7ba5abb06fc56bfaeb2ce29791a2e843fe52defa93c13bc7"
    sha256 cellar: :any,                 monterey:       "011718a59238f9909be43e638de8ff8873e7d246ada30c7ee6ff9e375995a251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a685392ff70e6e08ccbe5b6cc5f41570ae40ad12b097292261b96e9f350ea9e"
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
