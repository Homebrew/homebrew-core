class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.56.0.tar.gz"
  sha256 "eb83f7e98afeb3704d9ee0da2499205f73bab0b1becaf4494ccdcbe4295f8550"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c865826e73acdb762fc4acc120ff7c8f02cd6a662a963e24d9093d7bf447066b"
    sha256 cellar: :any,                 arm64_sonoma:  "5a0f70510c4bfd858b20822b082e59b83e0e55c82a9a0c0152d5e36728fc82e9"
    sha256 cellar: :any,                 arm64_ventura: "49f063b05f528fecbd2403dcfe1508e6cb020bda38405b8c2fbd3bffc9a8fa4e"
    sha256 cellar: :any,                 sonoma:        "406f99860f53e0c5bfec11ce11116cc51d15f614e31f7cc6c577286cc983715d"
    sha256 cellar: :any,                 ventura:       "119eec12ddde78b6e144d5b32c3fd2dd51bf4bb67de742a18d44a9d09d937b45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "571d04e9014fa65a030b07c7a0c393d16cd9d6df122655cfd6b8f3c3da72715d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae6d43676b89b6d4fd9b6438c06d6ca5fb22e348802570ab5059b905932ba18b"
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
    assert_path_exists testpath/"router.keys", "Failed to start i2pd"
    pid = pidfile.read.chomp.to_i
    begin
      Process.kill("TERM", pid)
    rescue Errno::ESRCH
      # Process already terminated
    end
  end
end
