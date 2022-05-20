class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.41.0.tar.gz"
  sha256 "7b333cd26670903ef0672cf87aa9f895814ce2bbef2e587e69d66ad9427664e6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "ecafe792b40cef127a5f34d06b6d4a2d887bbb52468d546cbba494abdb1d3ba9"
    sha256 cellar: :any, arm64_big_sur:  "e9e10b7b38236e95ee3bc7893bfdf086802c4e2733698e7e767c7514b8beccf2"
    sha256 cellar: :any, monterey:       "0b9b3ff3efc51f4c88d4b5f565da3778e906d2b948987740b8b1040afbb32867"
    sha256 cellar: :any, big_sur:        "7396ef0b74e60a44dfbdc46e55c566392c06e5f15116f5ccaa116f504f9252bd"
    sha256 cellar: :any, catalina:       "f6947aca1840031c034cd43fa36b57e6eaece869ae74054e5fb1c04c6e14eaee"
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
