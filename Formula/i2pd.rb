class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.42.1.tar.gz"
  sha256 "d52b55cf144a6eedbb3433214c035161c07f776090074daba0e5e83c01d09139"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1a73baaf386d2a35b5cfbf2f7dbd294fee1fc8c76e29e7b181c5ce3b48f43352"
    sha256 cellar: :any,                 arm64_big_sur:  "4cda48f56d5863d889e03ce2c506cbb1481bdd4d7a8ecb286e0f3c74c9d4e47c"
    sha256 cellar: :any,                 monterey:       "d2bb1f31c7c24141e030ef2144f288bd60a87499edecd0739b4ae2446d480813"
    sha256 cellar: :any,                 big_sur:        "1493e258f64e629569bcacb78dea5850053496f02c8d96c5c3905971a22c98b1"
    sha256 cellar: :any,                 catalina:       "1864323dd8bc24ba63702ed6ceed9b0c0daa529840f712e9f9c033d42b227c86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5ae82687c0223459a4db06a225b1d8af0490008356c8667b9201a4d2a670e3c"
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

    # Homebrew-specific fix to make sure documentation is installed in `share`.
    inreplace "Makefile.linux", "${PREFIX}/usr/share", "${PREFIX}/share"
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
