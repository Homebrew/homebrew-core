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
    sha256 cellar: :any,                 arm64_sonoma:   "9d7c9a34729be2155423be277a2cf260c8af6a6b08165283dcda96996d853c95"
    sha256 cellar: :any,                 arm64_ventura:  "a7ba511e76308bd483df294822bcb78355942bde03738ffadb8ce59074d7b5e6"
    sha256 cellar: :any,                 arm64_monterey: "101d996ebbadea8cc6b606cc4d91ff11b4e3bd95b1f617eeb586e7c0acea19ac"
    sha256 cellar: :any,                 sonoma:         "dad02f7d246c39eb75f5ea7e12ba9a908cf4e5017e3824d6870035b6c87bfcf7"
    sha256 cellar: :any,                 ventura:        "24a702e316a13c6cc1bbd9ba1270c4a7981706d138c35dc9d550abbf542297ef"
    sha256 cellar: :any,                 monterey:       "cc1c47304a05a724c39a9b4080830483a403df4a0ac371db3744c490146fd0c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6b66e7bedbdc15cf782231cff77c24d4b807c4d78cde0839aa1facb44bb22e3"
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
