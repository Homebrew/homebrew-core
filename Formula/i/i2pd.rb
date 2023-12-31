class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.50.1.tar.gz"
  sha256 "74c8fcffbadd10a5c3fd8a7a7a8557145fe95087898f5663123a707a1c72896d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "302d7869ba4f586c1c3759cca659a83c641d0d38e5d86b4d523537516a166ec2"
    sha256 cellar: :any,                 arm64_ventura:  "d0ac613b5c3d975f643441303e49141ee741d8e69701939c3c739d973728391c"
    sha256 cellar: :any,                 arm64_monterey: "541436b021c097956b52c26649faa1a9618419e90b12585de14fdee2c8428680"
    sha256 cellar: :any,                 sonoma:         "934fd093653620b490040d8e9d39d08868341bf975f0837e9f22fc6914ebeb15"
    sha256 cellar: :any,                 ventura:        "62c912add1efa0bfb516ba06e8733409e76cded8d9f08a6183c30dd8624174a9"
    sha256 cellar: :any,                 monterey:       "c495d8841192230ed1878d1279ef0e25cd43df44ab56d514ace04ca89158e481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bb0a865728eedf685a8ba0a9726f8b10afd2796547b957575b8c526088dc7f0"
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@3"

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
