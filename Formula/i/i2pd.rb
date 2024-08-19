class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.53.1.tar.gz"
  sha256 "c6863d853905e7594ea661595ea591055f8f2f018b9b90507d5a43a6456188ea"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5fd7dd481d1a6ab34a6bb20fb63310353154987784a6b0e82542511abe6e0e1d"
    sha256 cellar: :any,                 arm64_ventura:  "e0ffd5e80c76da7a096dee98a5c98c9bac175c9fafcbb61e5dc0236568a11bfd"
    sha256 cellar: :any,                 arm64_monterey: "33137c83eda0896b0af38a7fd0a60f25a0facb422c30f6fa3922c92bbc936fbe"
    sha256 cellar: :any,                 sonoma:         "3130adbee78929af125750073e6dbb6360022aad9f468a4c64bceae9da34d49c"
    sha256 cellar: :any,                 ventura:        "a535eb423006b8b9cfaf3b32f45b8e0556cde3c4f11ef09223e3124259d41592"
    sha256 cellar: :any,                 monterey:       "936399d51d014760e4b974a1a8a486b4f7141a0b6fc8c8c6583dadae22d0bfc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07f8e5145d6608a866bc773b6f897a7dd13620a094d451f1f900a2c839dc43e2"
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
