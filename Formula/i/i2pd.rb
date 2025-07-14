class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.57.0.tar.gz"
  sha256 "e2327f816d92a369eaaf9fd1661bc8b350495199e2f2cb4bfd4680107cd1d4b4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "17d7aec839b3a8641b2c40e084d459a787368d3090438ef57603038555504d0c"
    sha256 cellar: :any,                 arm64_sonoma:  "c609b3a58bcde479df1eb5d34c2dd6753812d5fb9a4e014a39f51a9cc2b8adf3"
    sha256 cellar: :any,                 arm64_ventura: "0d2ee21f5fa22ec7f632bf58cfbbe8799ad44d0bcb7797a6aa577f7e772a0751"
    sha256 cellar: :any,                 sonoma:        "4bc1ede8c8c592f58fd622f6dd1e230e1c134d787c0b94bf116d6f75d9e846f8"
    sha256 cellar: :any,                 ventura:       "415d938ffca8249d8ad6e32c1a07b35862277e42017ad7dade8fd8d0d554b19f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "773fde1a3a3f651d5fa7a1f14e3975f98b10abeec2a38c7f4f8f38fce9a39162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dd3123a2ddbb8e77da092236ed4152535742b9b49e57989d55b25bd50f4945c"
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
