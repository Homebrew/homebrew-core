class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.27.tar.gz"
  sha256 "74fe1447c8668adf910fa7a929fb6358aaf4a66ef734e751c5b8128071b0f7b5"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bbf5b1e791431a454dc810741ff6b9487d001b64db70bce6f3d8f1adf36aecd7"
    sha256 cellar: :any,                 arm64_ventura:  "2b803c8301e086733fb328d8a794d7aff8d546dd5e1d70de5c0f21855cd87f19"
    sha256 cellar: :any,                 arm64_monterey: "adf4d0aee786b21b5fc7b7df02cb0859f860e4b1f015e4e7d2e826fa455732f4"
    sha256 cellar: :any,                 sonoma:         "74133a7516010b95ec3d4ccd91fd842c43d032e8b9f818c9401b5ad46e3d1dcf"
    sha256 cellar: :any,                 ventura:        "3fcee6b3323254aa37c133b0b32e37544ded01437baa212239ef7acbf5a5e8e9"
    sha256 cellar: :any,                 monterey:       "ba7f98cac61453dbbd9690f79f4b500ccfbd791bebf0215af1b3835b3eb31220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c453024da1275ea488ae87398e001cf1a0890b22f256171e9f986cf788388fce"
  end

  depends_on "libevent"
  depends_on "openssl@3"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-coverage", "--enable-tls"
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
    assert_predicate pidfile, :exist?, "Failed to start memcached daemon"
    pid = (testpath/"memcached.pid").read.chomp.to_i
    Process.kill "TERM", pid
  end
end
