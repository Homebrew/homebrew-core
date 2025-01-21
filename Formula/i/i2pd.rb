class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.55.0.tar.gz"
  sha256 "f5792a1c0499143c716663e90bfb105aaa7ec47d1c4550b5f90ebfc25da00c6c"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bedb396fecb27939e03ecb75dd319d6a044684d48a8f82c6207fcbfb9152178e"
    sha256 cellar: :any,                 arm64_sonoma:  "4f389b2602c0f19e0fffe658bbb6fbfa629f0d6433e47dfa171189990bfca1cd"
    sha256 cellar: :any,                 arm64_ventura: "e2a56100608d855f3faf070c81e0fda796b932f6389d53967e3b4e9ff2ba9a16"
    sha256 cellar: :any,                 sonoma:        "e22ba89ca2bc7802a0748abfc37496bea830173b13790489f198aaef06653321"
    sha256 cellar: :any,                 ventura:       "3d8c4d99e64ab6c2384a722c4fdde1cb38cefc89e184971bbf49fb5406e3b578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5c85d194614531c9825616f5d31ef7025e51a817bcca55b2d1e04153bc0fa50"
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
    Process.kill "TERM", pid
  end
end
