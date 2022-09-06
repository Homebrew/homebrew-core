class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.43.0.tar.gz"
  sha256 "db1679653491a411dd16fa329488d840296c8f680e0691f9fe0d0e796e5d7bca"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "db52cf4513b14df53dee830dccc3f7c616414f18ab700245240a8f3589964d8e"
    sha256 cellar: :any,                 arm64_big_sur:  "f394f532f667ac1c0517948d21296570ac1c02584e024649167f47e3a61117f8"
    sha256 cellar: :any,                 monterey:       "e67a017206afb3adc32fbbae996cbbe34947921a256bd95c4cafc2a754cd08db"
    sha256 cellar: :any,                 big_sur:        "5c864dc961eb45d906dd71a2489a66319f7d368556b790dd905bf8cf1a46700c"
    sha256 cellar: :any,                 catalina:       "a94343a4472e833464044756d6b618f017455ffaa9c92ace525508018ce46bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a8e4c4b782b1b6dd3928ce1c7566310771421a6a08e95df4c581cd03919ac08"
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@1.1"

  def install
    args = %W[
      DEBUG=no
      HOMEBREW=1
      USE_UPNP=yes
      PREFIX=#{prefix}
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
