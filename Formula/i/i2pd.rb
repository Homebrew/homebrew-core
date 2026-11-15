class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/3.0.0.1.tar.gz"
  sha256 "e82d4cdcce71180a42f89a753012db9aa303a792afc3e442802761f099ee39e4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fa2215f7408627641f18b4bd209e5e288e564ffd376557ea9b419db59182e802"
    sha256 cellar: :any, arm64_tahoe:       "6738bb8b5afd3e42c8a13cd966c8e6895b729e9e49755ec0aed57c0d585e4308"
    sha256 cellar: :any, arm64_sequoia:     "e841c5994c8ebcf2a9195859de569107da920212281eef7bd74b647bc51fd313"
    sha256 cellar: :any, arm64_linux:       "9518101d1fcd84a9f26b3992f0bae9e924c756ad534bb08201c3b635a7a2e16d"
    sha256 cellar: :any, x86_64_linux:      "9fa2f09285867f6d5be9736d9464998a53254551274464c6dd34f886dadc848a"
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %W[
      DEBUG=no
      HOMEBREW=1
      USE_UPNP=yes
      PREFIX=#{prefix}
      BREWROOT=#{HOMEBREW_PREFIX}
      SSLROOT=#{formula_opt_prefix("openssl@4")}
    ]
    args << "USE_AESNI=no" if Hardware::CPU.arm?

    system "make", "install", *args

    # preinstall to prevent overwriting changed by user configs
    rm_r(prefix/"etc")
    pkgetc.install doc/"i2pd.conf", doc/"subscriptions.txt", doc/"tunnels.conf"

    (var/"lib/i2pd").mkpath
    (var/"log/i2pd").mkpath
  end

  post_install_steps do
    # Create symlinks to certificates and configs
    symlink "{{pkgshare}}/certificates",    "{{var}}/lib/i2pd/certificates",      overwrite: true
    symlink "{{pkgetc}}/i2pd.conf",         "{{var}}/lib/i2pd/i2pd.conf",         overwrite: true
    symlink "{{pkgetc}}/subscriptions.txt", "{{var}}/lib/i2pd/subscriptions.txt", overwrite: true
    symlink "{{pkgetc}}/tunnels.conf",      "{{var}}/lib/i2pd/tunnels.conf",      overwrite: true
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
