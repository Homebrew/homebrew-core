class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.25.tar.gz"
  sha256 "23d90c5261f756ca3ccb7d92bdf8ebf4976dac5d8ec27c6c0d60e5ad5db6a15c"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b491eaafad5ff1dc3cfdf6bd7710bdde21d645cf286d1dd2d2119fdea0fa091"
    sha256 cellar: :any,                 arm64_ventura:  "88763d0955d75249a12d0ef0a2e8a6d6aa4aab841cfe6e0302eddda4f722a3a4"
    sha256 cellar: :any,                 arm64_monterey: "5425c69576cddb710c807834d4a364cc2b5dfcfda450cb0c4d6c8bdd5e302df9"
    sha256 cellar: :any,                 sonoma:         "6c73ace600a991dd33d4a1741bc79d2b1deacf73a758b3040cff9c8bc862cd37"
    sha256 cellar: :any,                 ventura:        "356923c553f711592b65e0ab9e46215b15109b3a1ba80ec014bd9e8c5be5cb2f"
    sha256 cellar: :any,                 monterey:       "f90a544b0b15cc2cbd7160b91bbba1a31cf5c3c70027c4fb2fbe50730f63851a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d10d6760d475c10a4281c482f083cfa7dfb631fd0702f7c8c8467e7dfe481a03"
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
