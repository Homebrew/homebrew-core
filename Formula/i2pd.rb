class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.46.1.tar.gz"
  sha256 "76b41d02a41a03d627fcd7fe695cad7f521b66e99a04ec9678f132a1eb052bb8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e669799a25dcbb6ec0cfe5e8445f24b147bb7637b56e6d324e9565228ff622c4"
    sha256 cellar: :any,                 arm64_monterey: "c638d69fcfe3ad8b353e87276a772c296fede838c81f5e6b1dbc1a928adf47f3"
    sha256 cellar: :any,                 arm64_big_sur:  "03adeb73e6e460a81d690e39dabfd58b2d9becf4420f489f6f6ffc75260a98b9"
    sha256 cellar: :any,                 ventura:        "caaf54a6a98bf59206615a21d561c6d856cae65d9021a98876d6840054667ea8"
    sha256 cellar: :any,                 monterey:       "16216f9797ed8ce16e83c863ad95c26eed8d6eee299ed8df8d7d26832a20fd56"
    sha256 cellar: :any,                 big_sur:        "7e0bc3289c8ba31282d9b7cbdc37c10a1bc4c14f7dc80d304c82b6a4343049a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e4377bdf062c5084586a990318d0819158614d08ca4401dd9a21e4163800f28"
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
