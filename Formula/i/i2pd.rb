class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.60.0.tar.gz"
  sha256 "ef32100c5ffdf4d23dfe78a2f6c08f65574fd79f992eb2ac8cfea0b6440deabd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "af49929dd0a31b33d3ccdfc6722a59fabfb7666977f89bc4bc23be534bcf4456"
    sha256 cellar: :any,                 arm64_sequoia: "e7ea6e15cb9892cb341e4c91658fe044b2ff2d31e95daf5770beda71d14bb8f9"
    sha256 cellar: :any,                 arm64_sonoma:  "a2ebfaf4c20175677a20fb8eb6fa004607a285d763bfe6980e89301cdaca40d5"
    sha256 cellar: :any,                 sonoma:        "05b2888fe4c0e9160b2d1e662776d63df7c3829949dc156b0636e0b63b14edb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97cbe731063c25d8da13e9415a76364ffd934c663c76e4e27a15ea0d1fb8d29e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "583d1aba1ff58e57647122f95d74760ea6a1d5e332f475e10c2c718726093349"
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
