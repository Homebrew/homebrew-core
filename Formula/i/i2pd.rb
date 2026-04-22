class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.59.0.tar.gz"
  sha256 "0ebeb05e4f36ab3809449561a095dc767ad821ac6a61c95623ab49be4ffd398b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b1bce7c4d87cff3a5381fa39b080f6056c59ec0fb4ef7981cd70f4a5d23fba83"
    sha256 cellar: :any,                 arm64_sequoia: "2b051ea8a4290bdbe093b9f7d1a9bfa8c1503adaf11b57afe0ddecb8e68e980f"
    sha256 cellar: :any,                 arm64_sonoma:  "c51bec09bd9dee15dd8bc26d4d40030635c89a0cbb2d555201d7471edc030433"
    sha256 cellar: :any,                 sonoma:        "ceee3280032116573f4f4c96b15d132bee87d78c5a09cfdf5eb7a250c7b31ad0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bb7c13319b1c425952067ab4eed17953f3825c3ca1c3243718de466a440a283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b794277fc76a16aa1cb5789d988a15aaf4f1801f28aed8815f396945aa834f4"
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
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
