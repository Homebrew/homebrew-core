class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.58.0.tar.gz"
  sha256 "5ff650c6da8fda3522c10ec22889a7fd1c6b5d1af42c24531d84c36f6cc49019"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b1e46138ec28478b5afcd12826198db06a06a3c4870f161faac1a3cb84555842"
    sha256 cellar: :any,                 arm64_sequoia: "cd47aa2172c982f58e69d49e68ca0ea2b7c84513cb1ee39346332e20f3f860ca"
    sha256 cellar: :any,                 arm64_sonoma:  "ea7d40766fe66d17d5ccb5d4fcbfae5784197e5f30b79f82bfd380c3a234a508"
    sha256 cellar: :any,                 arm64_ventura: "6a8ed761563b9d3addc5d27d6eb3bc89ca35e880f274d5ae8fb6efafb32df50b"
    sha256 cellar: :any,                 sonoma:        "ee7e9c640981eb3865fedbfdf5b8df35e8886788b6dbd109286e695dc11a39a1"
    sha256 cellar: :any,                 ventura:       "92996a855a0f00acde3d0d0375d135d55c64bd82e34dd878b680a741a9eea72c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1258801853ad395c0c6d76aa0ee86ee5cfdf47bc49751a04f3383187d1d96c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a91374226f2045b40b669e1ddf532eb363f73c21345a8da3c04a7ac4c40e09fe"
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
