class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.56.0.tar.gz"
  sha256 "eb83f7e98afeb3704d9ee0da2499205f73bab0b1becaf4494ccdcbe4295f8550"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c9b463410459b90a2f019b21fbf428dafa4933f7e41353b71e699da7d526254"
    sha256 cellar: :any,                 arm64_sonoma:  "5ba44bba64e419dff6ecad8514cc96e4d37edede35242773f8ea8ecbafc0c5c5"
    sha256 cellar: :any,                 arm64_ventura: "1d499aed3af1323d25154f2b2f1a0b0fed00fa097d0a62a678de7f0fab33d71f"
    sha256 cellar: :any,                 sonoma:        "f578d1255ff89301087528772cee5270bb0079cf7fa25a12c321587c863ef0f2"
    sha256 cellar: :any,                 ventura:       "f4460fa5449590dde6f5ad3547f27c16e772abf7ee2ffb45fae64735e683b26a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62bd790bbfa967fdcaef86f20c80ea7ea810ef8a60aea67f8eb75fd94a6378a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "576df48024466961c4f87017af17d859f7ea8a289d848012f2cc67b6e4eea404"
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
