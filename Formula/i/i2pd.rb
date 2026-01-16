class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.58.0.tar.gz"
  sha256 "5ff650c6da8fda3522c10ec22889a7fd1c6b5d1af42c24531d84c36f6cc49019"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "48c3ff51d49eff5f8a561137dfbe5f7e0cd2c1862d145c2aeb703b25aa3404e2"
    sha256 cellar: :any,                 arm64_sequoia: "73849c19b4aa220d455e260502a3dc31c9089332fe3118d17b426142831526e5"
    sha256 cellar: :any,                 arm64_sonoma:  "69ada8d3a422c1a750a76ba315a5314a43c8cb7b16f66eb3c016c599c63d00bf"
    sha256 cellar: :any,                 sonoma:        "84a526c1afa6cecfe786af3c4bd60043851a103d5d87cf7df4f77d39c4122642"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60220f3a2b8d7005ab5301cc5c9cf97659f2a6d8cf49f0018b36dc0730df46dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e542ba83f222a34d9edb58b30e932b39483d2a3f0e35c21f96f5d2ef54367aa3"
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
