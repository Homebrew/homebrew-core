class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.21.tar.gz"
  sha256 "c788980efc417dd5d93c442b1c8b8769fb2018896c29de3887d22a2f143da2ee"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "196207321c5c4879c317b3a95fd7f68a5d626b1bd6f8936863c10a18760e1a95"
    sha256 cellar: :any,                 arm64_monterey: "c53e839cafbcab3d9d556b47e98e4c2b3cfdc5d3955f20a1a96a2630044b9c7f"
    sha256 cellar: :any,                 arm64_big_sur:  "968abfe812d12700ee240e0f60fa8a8781dc11ab27ad5163b579f1f7a247c335"
    sha256 cellar: :any,                 ventura:        "4a9cd23657aa85481e73b6e1f205e5a7569fb8f8f5b8ced650433ebac261036d"
    sha256 cellar: :any,                 monterey:       "4ec6052c3c06eeb1793719d4cddc0da8404ee8220ea505b643ddbb7bc514242f"
    sha256 cellar: :any,                 big_sur:        "ac5212e3d74c4e0151c6ba1accacb022d03182781eae3da68c900f527ab16b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f583c77fc1837abf3ae3576d236856f8464b4834285898829c6cb28bf0aff96"
  end

  depends_on "libevent"

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
