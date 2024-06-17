class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.52.0.tar.gz"
  sha256 "f5fafa700b61d0791d37bd8eee04912582ea5e3f3b1d80ec339bd8158a30995b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7523375ec4ca1be89a87b17b0dd6f092e9cb4eeedb331225d4f8ddca72d5853c"
    sha256 cellar: :any,                 arm64_ventura:  "c9ae2353c787198debcf3c8e37cbc678e2fd7f255850f4d08dcf08162e484bd8"
    sha256 cellar: :any,                 arm64_monterey: "17cf7d01d2379c0f8e81b62c7ade35e62dcf0b8311f2f9f264a23119cf4ae4ae"
    sha256 cellar: :any,                 sonoma:         "0588859847e32374edd9b66d65d371c8c6ef5102816de1cc2ab6a9f5b5aecfc9"
    sha256 cellar: :any,                 ventura:        "873b435f078b2dd022b0bc1f6989375abbe7d9d270c25ce3cd070fb175394696"
    sha256 cellar: :any,                 monterey:       "51b8a226dcf18a62c6729e7284d94d977b9c534ac6fb7bb5b62eaad9ba1028b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eeb1b137f151e21e30a01617aa76a897a36ce44955036c78cc66b99d5b9c3e6c"
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
