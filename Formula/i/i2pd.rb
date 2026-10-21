class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/3.0.0.tar.gz"
  sha256 "3bebc9567658944d388c382fbec61b7bc583dfa9982028b42b96eeb354f79bd3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "18a66e12c054f844acc2bb91724d0485f6b8a8b39f0f2cd06e27515348b6b0f4"
    sha256 cellar: :any, arm64_tahoe:       "54a9027eac10f00b8f2ae221712e286d9a23c716c2b518f4b88c33d64f249e5d"
    sha256 cellar: :any, arm64_sequoia:     "f6eae04cfe67429316423c98213a86fa4508e41bd4df2ae0857b70cbff7087cc"
    sha256 cellar: :any, arm64_linux:       "20dd540648b8e68367323252731edc91ef520b5e78d67d42e552fbfdeb5a567e"
    sha256 cellar: :any, x86_64_linux:      "aa58c37e8468b55fe435de6f1969475fd5823ea9e2137473b08f6d55ba95ddeb"
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
