class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.51.0.tar.gz"
  sha256 "d7e4fe2c5c3c00a9115f061b797be3d2fc81bb25beddb20a636ae2b0c912ce31"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f4aa5aa537f791864bbb4094c3c3c9c6fab6a8d3c3b13e46c78ab57573aaae5"
    sha256 cellar: :any,                 arm64_ventura:  "dd6602f2aae4acd177a24bb7586733d97aa4fef061ae329ebe8a7faed77fb522"
    sha256 cellar: :any,                 arm64_monterey: "daa50e0f7f34ef455ee9a10220c907a32ac410cbc1257a402053b6291150a7e6"
    sha256 cellar: :any,                 sonoma:         "9fd2ebad26561e4b934966cf02eca5f23ff1a446769ff112514a65423414480f"
    sha256 cellar: :any,                 ventura:        "8bb027ceb72a1baa9ca83e1a44cceb7b40af21d106a13bd506891cc6a073aec2"
    sha256 cellar: :any,                 monterey:       "d4daab62fefbc46b5d84916df55111b396e25c2ae5307c818619c2e0bc21016f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec2fcd1f58f6c85494ec43f7a0924acee250a6da93444be81ed9f5d159a348de"
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
