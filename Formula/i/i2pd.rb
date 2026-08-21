class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.61.0.tar.gz"
  sha256 "409cd3c0257491286611ab6aaf690940c7248fb898377c13fadb65a836e2a0ab"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bbb312e11ddd3a87d24916943a010855aa479d41a9023ff2f132e7542f1eb9e1"
    sha256 cellar: :any, arm64_sequoia: "744b5ed726c6c370d13ef44928636f9d8f109cdbdc6a8aac2afe2aaee27aa4cc"
    sha256 cellar: :any, arm64_sonoma:  "da60b20f5e1d5ed9daa270863bb5d6b9b852e646b70b780bbb2dbfa8026b9d51"
    sha256 cellar: :any, sonoma:        "29c619d92c0c49286881fb81551e82c520b1d6e8056d42c32f97dd98076fc114"
    sha256 cellar: :any, arm64_linux:   "561e64cae448454b85a96b604f00803d23f24ddfffa8e1a4f56aefc7e4e869c0"
    sha256 cellar: :any, x86_64_linux:  "fac2896ca3f31cc74fb4ee816c05b54027fd3b871d9bce158d8e48922c54e691"
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
