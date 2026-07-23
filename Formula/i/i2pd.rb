class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.61.0.tar.gz"
  sha256 "409cd3c0257491286611ab6aaf690940c7248fb898377c13fadb65a836e2a0ab"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eec5b9e08b05bd53f163f6d154ea442b8a889803a0efc46c9d23eefcaa591eda"
    sha256 cellar: :any, arm64_sequoia: "3ff45ae6ce234ecf3fbca0669a0e046a4a1754dddd1d12f418c84e22e8e110bd"
    sha256 cellar: :any, arm64_sonoma:  "344393cc55b6c849feb06841aa6a7ec6247d5c541b75ed20b33f883de8f28d4f"
    sha256 cellar: :any, sonoma:        "8d5b49fb79508e0e11a6040d8c89026efbad82e6b4a13787ee896e0280c6f137"
    sha256 cellar: :any, arm64_linux:   "03712d20f3bc3aa1603e5345f298e6c64bf031d459749136895c35d31a0c0f83"
    sha256 cellar: :any, x86_64_linux:  "514b89d2e86b297b508fef9b56c3bf88a985dd0e386ef2fefde45162fcfffe49"
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
      SSLROOT=#{formula_opt_prefix("openssl@3")}
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
    ln_sf "certificates", "lib/i2pd/certificates", source_base: :opt_pkgshare, target_base: :var
    ln_sf "i2pd.conf", "lib/i2pd/i2pd.conf", source_base: :pkgetc, target_base: :var
    ln_sf "subscriptions.txt", "lib/i2pd/subscriptions.txt", source_base: :pkgetc, target_base: :var
    ln_sf "tunnels.conf", "lib/i2pd/tunnels.conf", source_base: :pkgetc, target_base: :var
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
