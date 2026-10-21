class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.45.tar.gz"
  sha256 "d362c64e6d8d5287153501eabf7c85b4a761432fbf53f5d7b085d0bb1653c1dd"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "adcec2656cc32726c9e67fb454b1d9beb7b1309ec5e2a9fe7dc95dc357e64047"
    sha256 cellar: :any, arm64_tahoe:       "ed2644aa3dcaf9d01babe0119a2c36e61a7d31f6102ac0a76730a2d5b1720dd1"
    sha256 cellar: :any, arm64_sequoia:     "3a2adb1dcb72fe37ea2088612107cbdc25e4c7c41e032c2ba6bfae891bcd21b2"
    sha256 cellar: :any, arm64_linux:       "a3be4be81ed3a670a80df36db63c2768f8350af307f5f702e228cc02f59ccd88"
    sha256 cellar: :any, x86_64_linux:      "8a3a653b86bafa6c73c79b5f4e36c9bea21dcced2c6d84cced8223aa587664e6"
  end

  head do
    url "https://github.com/memcached/memcached.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libevent"
  depends_on "openssl@4"

  def install
    # Workaround to disable sandbox feature due to https://github.com/memcached/memcached/issues/1313
    ENV["ac_cv_header_sandbox_h"] = "no" if OS.mac? && MacOS.version >= :golden_gate

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-coverage", "--enable-tls", *std_configure_args
    system "make", "install"
  end

  service do
    run [opt_bin/"memcached", "-l", "localhost"]
    working_dir HOMEBREW_PREFIX
    keep_alive true
    run_type :immediate
  end

  test do
    pidfile = testpath/"memcached.pid"
    port = free_port
    args = %W[
      --listen=127.0.0.1
      --port=#{port}
      --daemon
      --pidfile=#{pidfile}
    ]
    args << "--user=#{ENV["USER"]}" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    system bin/"memcached", *args
    sleep 1
    assert_path_exists pidfile, "Failed to start memcached daemon"
    pid = (testpath/"memcached.pid").read.chomp.to_i
    Process.kill "TERM", pid
  end
end
