class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.56.0.tar.gz"
  sha256 "eb83f7e98afeb3704d9ee0da2499205f73bab0b1becaf4494ccdcbe4295f8550"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "511fa269ce664d6f11bcf59a497bee0598c5801be4831c19a4fc9c695c071e05"
    sha256 cellar: :any,                 arm64_sonoma:  "fc44c7b9bcf177eb06fc5f2f18325015f3372d16a6dd5f5e9697c1e98c7c332c"
    sha256 cellar: :any,                 arm64_ventura: "765fe20c75d136c406e503e0aef6225a575d27070dff1918e7cc4bec561ffb65"
    sha256 cellar: :any,                 sonoma:        "98cb30e4d9380b10b1463ce47d4823f4def228d4953811a35f0cbabfa9c5bfbb"
    sha256 cellar: :any,                 ventura:       "5f18cdf5bb827d6fab2f4ff0661f7be5a2c08086d5a8cbbb1a82c35c3f9ad958"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07c6f097a50e0bc19d5984b1d72ad7a5e656c1275daa8c3491b27e2d7bd5514d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1a5462d9d85b03007dc93b0a8174fe586e56a771c86bea5bc975e3ba1701ec3"
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
