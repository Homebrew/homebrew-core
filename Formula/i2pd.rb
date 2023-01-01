class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.45.0.tar.gz"
  sha256 "4050c0a38fda06a76defbd2721f468f5b09889ed7b6b5a7e207e4659d300738f"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "450dd855164a0aba0ef2f5b7bf92a125a2017603c0e098ca6c08e0b36dbfa930"
    sha256 cellar: :any,                 arm64_monterey: "2496a89b0db27dea198a7e00973aa4a18f63ef8427b377a79fcf6f7b0dc38ea6"
    sha256 cellar: :any,                 arm64_big_sur:  "df0cc3ce1eb094265e6402070b82e5998f338d758bf78c842400fa7b307941f5"
    sha256 cellar: :any,                 ventura:        "8c3a4ec9e24af0200ec0df40c0657f0e4ef30ec30babbe258db434af7c61b2c3"
    sha256 cellar: :any,                 monterey:       "5c88eb38b3e0fb3360f964987d29db6f49ad6ba18759d5358c063d81e904a34c"
    sha256 cellar: :any,                 big_sur:        "d84421e9669821d25ef3f9c14a7ff22286ba6fc30dac7460a234f157c49bf483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b1f53ba9eecba99bd28998d5ab6d3132ea2da66d097c6f829796095bf44d4d5"
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@3"

  # Upstream issue ref: https://github.com/PurpleI2P/i2pd/issues/1836
  # Remove in next release
  patch do
    url "https://github.com/PurpleI2P/i2pd/commit/acd6af709ee6371b3d0340d2c92cb86f6f4bcb97.patch?full_index=1"
    sha256 "54343ce6a8cf970cd65c9b39c55b3fe15f28c3a1dc6dbc07df870ad8118cebc7"
  end

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
