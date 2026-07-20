class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.60.0.tar.gz"
  sha256 "ef32100c5ffdf4d23dfe78a2f6c08f65574fd79f992eb2ac8cfea0b6440deabd"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "1c753de7fabacfb80a3bcf4a0daa2f3294c0236a46aeb471abd0d04660b19764"
    sha256 cellar: :any, arm64_sequoia: "8c992bb3ffcb38f25eddd33e67cfd44f2a3e1a609760c421deb77f765ca8e7bd"
    sha256 cellar: :any, arm64_sonoma:  "27f723665ada7b93325ecc9d040b4956b77e024bb454d73d64105402b65397a2"
    sha256 cellar: :any, sonoma:        "00b696213cad837286229074610faba65519a08203102d36fcbad118664ba020"
    sha256 cellar: :any, arm64_linux:   "362079b30cd2dda5ea9151afb162a15eb78709dcac3cbf9af6c20bdf0ab2b29c"
    sha256 cellar: :any, x86_64_linux:  "e832fa2d871f36e71847d5aff3fd56a7ebe10f3e3b613c9ac9e7169dcc28e432"
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
    symlink "certificates", "lib/i2pd/certificates", source_base: :opt_pkgshare, target_base: :var, overwrite: true
    symlink "i2pd.conf", "lib/i2pd/i2pd.conf", source_base: :pkgetc, target_base: :var, overwrite: true
    symlink "subscriptions.txt", "lib/i2pd/subscriptions.txt", source_base: :pkgetc, target_base: :var,
overwrite: true
    symlink "tunnels.conf", "lib/i2pd/tunnels.conf", source_base: :pkgetc, target_base: :var, overwrite: true
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
