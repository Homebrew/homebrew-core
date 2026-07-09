class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.44.tar.gz"
  sha256 "c41a9d2713dfc56b5f4fa0075b2751973ea840c1f1ab8d6bfed08a1848938368"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b4c49089eaa5e498baaed49f1cf24ca0337ee9db1d0e2da2a1b910ab2e876e98"
    sha256 cellar: :any, arm64_sequoia: "8fb9e7e4533587a45e4bac0d3daf3dd67324239d1c6f22b3eb0473d32f3e98dd"
    sha256 cellar: :any, arm64_sonoma:  "41e5e84e63863d561a57bbcba30453f8bcc27cb1566f1b13821600604000cd08"
    sha256 cellar: :any, sonoma:        "d2f4b7df7e2b06a3985315f868d3cbdf4730c0312440c4280e19dcea4c4314c3"
    sha256 cellar: :any, arm64_linux:   "f88952746b71452d13ad7dd5d69c559b287c63056e86045359807913be33cbab"
    sha256 cellar: :any, x86_64_linux:  "510486081201c9e96e0f364df61f705e1485a770d74d2a400fd191115345f08f"
  end

  head do
    url "https://github.com/memcached/memcached.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libevent"
  depends_on "openssl@3"

  def install
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
