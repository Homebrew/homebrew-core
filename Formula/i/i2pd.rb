class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.51.0.tar.gz"
  sha256 "d7e4fe2c5c3c00a9115f061b797be3d2fc81bb25beddb20a636ae2b0c912ce31"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b28e0310c50f358e22c43b73385d55e715bd39256308f59cae0e029af23d2c21"
    sha256 cellar: :any,                 arm64_ventura:  "6dfb8cffff80ec6b5beae87050cde7652b15f9d3ebb098eef71ac7ae7f726d19"
    sha256 cellar: :any,                 arm64_monterey: "a589ffb93c69bbdfa0230eb75389fe410aced210426f473f7e9903f0141b5290"
    sha256 cellar: :any,                 sonoma:         "3b456b1a723687b762ef179edd8c612d58cc4688e29e582bb4b69e788509b78b"
    sha256 cellar: :any,                 ventura:        "0dde3d3fb8a45cfb28ae8e86f2f505fad2b21e4d3f513f2310146ef628d24093"
    sha256 cellar: :any,                 monterey:       "7ccf9df91317ea381ea4beaa60194bbc83f325ad60fc72a6874ddc925fee4951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20d24d9e9c3ee0c46970db77576f17b7bdb2aebb0880e8a5f8d3d5de40820df7"
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
