class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.49.0.tar.gz"
  sha256 "d8e07f78cc9f1ba65e8460db27c649dd0cfdd3ba334725f8d6f9ee815cb40e68"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d894067ebb3756e9d32e1c7d3930d9deccb012ae544a307a9d255852518c1671"
    sha256 cellar: :any,                 arm64_ventura:  "8a845f109a208d1b4507c9dc406d448e3126d5d778ebdb9472f7d275757b5a4e"
    sha256 cellar: :any,                 arm64_monterey: "e3c10b7bb1f6e048c3cf32e4f13a69e981a128b850517782cc84954553a92273"
    sha256 cellar: :any,                 arm64_big_sur:  "89fb8e47c6ff0fbbbcd0e21699438d510ae03e3fbbe958eff9a87cebf3346171"
    sha256 cellar: :any,                 sonoma:         "c704c0da3224e615a1e3c3fe9769eb18f007d3d7f294d3692433e89c484f57fb"
    sha256 cellar: :any,                 ventura:        "10737ea8eca3c502fda677d6719acbd0f093a96e0c605aed2a15e41d03ce71d9"
    sha256 cellar: :any,                 monterey:       "d911bfc93c106e2626d07fa0c4009846c873025ef4fbe7c9b399567d70ce2666"
    sha256 cellar: :any,                 big_sur:        "53011ce5df89c0df9203cac60372b325d5e2745fb611ee8929ad2aa90a267203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f8c3b889a96c29814dfee2831fe473582af55da281f0321c545f4dc29e15e16"
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
