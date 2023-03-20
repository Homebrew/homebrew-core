class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.47.0.tar.gz"
  sha256 "c988baf23215c37d5f566b7b2059a3c168c78d157eac6dc04a30ac266c6335f0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "224fa30c3ceb3b8d154d33b78472a7a89adc0367fedff1900db0c1195ca7562c"
    sha256 cellar: :any,                 arm64_monterey: "c280799689ef20dbe4c63ac59a38ced1ad44ae0981d6471a65f9ad30b26fc44a"
    sha256 cellar: :any,                 arm64_big_sur:  "7f9d3f073d4e23c8fc8c86c04bd59c86a68050f35ed28a10aaac616addece86e"
    sha256 cellar: :any,                 ventura:        "80666bc1643f7132edd7f17f67627223affcd50f5f3876d081307fefd483e346"
    sha256 cellar: :any,                 monterey:       "4eed2fe4473912b3d42ca6aa2439c1f65aa874afa73b1ee86fb08b47abd70775"
    sha256 cellar: :any,                 big_sur:        "88593781528dbe1813b94a5a12162bd3aaef2c5b81adf3342eb13f0c81438543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d5426afd3b91529ded9aad53896bec18ddfbfee5bb4dc3da719ea76de9f7cff"
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
