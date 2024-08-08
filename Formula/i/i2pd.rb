class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.53.1.tar.gz"
  sha256 "99c3d739530b08b28a796544ead4254394c7226a873bf813db4e7b3c1524d757"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "50babedaa7726acccdaf11ecb5a144d2953bd52e3f6084db49524924609a0832"
    sha256 cellar: :any,                 arm64_ventura:  "21f79648538f2eac0abf9b9b1240b966f0edfd897ee08d77875ce9cc6e2c6455"
    sha256 cellar: :any,                 arm64_monterey: "9e4e47d59e22dac059f86ae47dd510d0089969371ab0e681cfc4e2524991dbaf"
    sha256 cellar: :any,                 sonoma:         "d1b0e796b5e39c80dad02b8b880706f46b2c13158f10b122197f600ec4e0337e"
    sha256 cellar: :any,                 ventura:        "16c54ca004d3c0e60e0a55d27b66ae86f9fca0a1f106c53ef0cedfd55d22b671"
    sha256 cellar: :any,                 monterey:       "0b2b91c5afeafa17f1c87ce61496ea6e5012d80068531cdb47bb6555011b4eb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b12898a98fb525e6d3a0ef27bbe6f07badce23281489137c7cf0b878f6f603c"
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
    rm_r(prefix/"etc")
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
