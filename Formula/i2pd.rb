class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.41.0.tar.gz"
  sha256 "7b333cd26670903ef0672cf87aa9f895814ce2bbef2e587e69d66ad9427664e6"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "550dc26ffd266bbf7b913f132fe4aba1c04e94a43e3604f32e99a0205109726c"
    sha256 cellar: :any, arm64_big_sur:  "df56a21abd4fd938d18861b89a3b3c2915de281d0d48691b252aa2a2995d8216"
    sha256 cellar: :any, monterey:       "0eeb3cb89d507c2bc2c5e2efc3b723f1353fb957fd652e03053cbdd7042d049e"
    sha256 cellar: :any, big_sur:        "518e30dd51f2bfa19f0a4919fa54cb1ce1b426ba9fb8c8af759ad193cba6e00d"
    sha256 cellar: :any, catalina:       "57cbbd26efba51eba1391e59f1499e066971ae6842c8eb95c3079cedba37c2a1"
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@1.1"

  # apply commit 5c15a12116c1e4447b94fd0f36caecfd2e5a40de to fix mutex lock on stop
  patch do
    url "https://github.com/PurpleI2P/i2pd/commit/5c15a12116c1e4447b94fd0f36caecfd2e5a40de.patch?full_index=1"
    sha256 "bc3b1234966bd7d7dd13dcc71fd72f8db316b865aa7fb4e7bffa4fdd2efa4eb9"
  end

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
