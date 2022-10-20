class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.43.0.tar.gz"
  sha256 "db1679653491a411dd16fa329488d840296c8f680e0691f9fe0d0e796e5d7bca"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9e432865cf965f2cb060e36eab9898daa3581421aabeeb582e31e700d7ae4a0d"
    sha256 cellar: :any,                 arm64_big_sur:  "afe25b772d258dfd029759dc54505c585609c5c47dd0fc38dc440d0b0aa1fc42"
    sha256 cellar: :any,                 monterey:       "bdec83561335dafd0108c691b33e54023ddc58e6342fce3f40d5163ccfc27e90"
    sha256 cellar: :any,                 big_sur:        "06c21b1cd8df6be40479c522e91fa0d7ed0fc4c7316d401b47a9cb930a88c51f"
    sha256 cellar: :any,                 catalina:       "314ff35843446d01face4630258cbb3af6c5a73355d058ad9fc2d7b5424b62f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "137234a5b2f210b7bd1db7450120ac8e22c390f256b796d33769ca163a245497"
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
