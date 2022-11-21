class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.44.0.tar.gz"
  sha256 "b653c845ac7a16fefab2ace78e3ae496c12b05304bb66e41e776071635d4e070"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "428523046ee5eb138bf0d745c7adc20604a2b8348dfd37952226c09ef717db6c"
    sha256 cellar: :any,                 arm64_monterey: "e2a7c0001e541b027b7b969c417aa07fe66b979cd42f4f91ff94d545d92ed608"
    sha256 cellar: :any,                 arm64_big_sur:  "fd309abd53ba63105aa276b5b5d27d561095057d9c71da25ae8fb2b1e0464933"
    sha256 cellar: :any,                 monterey:       "7da92d874561d362b3fd66a2fd413a3464c86137fe94b1cd599925b752835617"
    sha256 cellar: :any,                 big_sur:        "55b2608f0ab14401ea035344687c757c346714a5aee34d54909c9c0d7e0910c4"
    sha256 cellar: :any,                 catalina:       "11a7435ef5962ba2fc2f8836faa5494fa9a80780e279df004d7045a77ad96bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe5ef7064d6ba3018e64288510c5d5fd59bafd79af8ef817d51177528f767286"
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
