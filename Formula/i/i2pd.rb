class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.54.0.tar.gz"
  sha256 "5c3f703417bb5f3e5dda642d39c5d30593a5dcf69d5a5ecfe82d5e8a7d454aaf"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8cf3af75a10a5b7a03054b3ef0c90e3ba39337a06f8a6325f2476c1cbebdccd6"
    sha256 cellar: :any,                 arm64_sonoma:  "52a22137f9fab8fe91a767490b672fa04e3018abdcba29b223c0c100252aaaf7"
    sha256 cellar: :any,                 arm64_ventura: "3835e6ec875545c06531550bdc09edd6c23d5a0774550b20ae35f962b833ff6d"
    sha256 cellar: :any,                 sonoma:        "bf628805328fe1b0683a63b1ac4139b6c333a281c113db6919a717fa8c4abe6a"
    sha256 cellar: :any,                 ventura:       "156e5a4e93c57c42ee35a0e078a0804671631f22c736e3804cfe496380e26511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f96bed143d8206efd421c611f31313288d0d2c916ff45174d5a569fbe88caea2"
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
