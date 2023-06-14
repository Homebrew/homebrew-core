class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.48.0.tar.gz"
  sha256 "ccf417aa66ce37f72ea15b7fbcff4c71e823566ea74bda696b9c1e19aae08739"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0f402e359268fdc3d5cf2041ff201777082c831f0d076865b9ecf825f8ac2e88"
    sha256 cellar: :any,                 arm64_monterey: "a15c7fe2caf7f245e84b2cbf4835f24765cc41dba5bc1d57db365340aac4078e"
    sha256 cellar: :any,                 arm64_big_sur:  "ed3864fd2e438e446efc423c5fd6ba8e0f639d5a3e248e724a91a10a7fc1062c"
    sha256 cellar: :any,                 ventura:        "5e1d53175ec7c82c5afe667b7fb65bf5d2044b20d65510a9688021501d023757"
    sha256 cellar: :any,                 monterey:       "a69a1e3729a2791797ec75cc9629da2df4df2fba36755736e69b38d163a9e4ed"
    sha256 cellar: :any,                 big_sur:        "403fd0dffaecdff49cd2d1121d0db2df31e559483c33d2a6fca0f0b39d103f1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5257e043a6165e9f0079f9292e05bb33a3aaed9f4ad226b3b1d147906990f49d"
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
