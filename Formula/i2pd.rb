class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.43.0.tar.gz"
  sha256 "db1679653491a411dd16fa329488d840296c8f680e0691f9fe0d0e796e5d7bca"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a12f86351082bae3f4a75a69307cfaa741fca3e79db07c15a6bb29507bbe21bc"
    sha256 cellar: :any,                 arm64_big_sur:  "b5e5ae177fef767c7135a3db7bca61f67c8f9ad68f80327f0a9f6fd9a565a53b"
    sha256 cellar: :any,                 monterey:       "506743280af1b2b7b3e4dfe5f222c079a427963226b110e5f74135b6db90cc16"
    sha256 cellar: :any,                 big_sur:        "15d852e3257f88e3ee31735e385d1f5b72a7479ce80272c12e80886231cd0c89"
    sha256 cellar: :any,                 catalina:       "f177a2a379f9380cbe1e08e669ef874b2bff81a23e9b4b8cca04e75ccfc15628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7cd0bb29c1a43c314c5a90d211d02146f82353ab1a55cd331a9aa79fe5f1aeb"
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
