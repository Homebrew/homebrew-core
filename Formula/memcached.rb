class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.20.tar.gz"
  sha256 "8f604f8e3a175637dc1f069de6fa2739116850c9f81e3764f2fac9a3b27be307"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "920f927eea05edc5eb395d1098f53ae610d9ca9697487f22be2d843beca58c6f"
    sha256 cellar: :any,                 arm64_monterey: "aead80e56eb7297841768124c26301dab5b0f8995fb5907cf22cf5994a7c5d98"
    sha256 cellar: :any,                 arm64_big_sur:  "d3578fb4c204a793a251b93ad1f4e75e214e985ae543bb2a122b6c6e53c37638"
    sha256 cellar: :any,                 ventura:        "d8de6ef52a2f77f8ece303155ae338ffd9615e92e14690fcfcf53a4d6227c631"
    sha256 cellar: :any,                 monterey:       "b0c48eeddcb510dfc6995f01198a5787c1ec0165d6aba081b0832e9cabd8b611"
    sha256 cellar: :any,                 big_sur:        "c3f19f92020de53a073aba00225736502459902699a65266c2aa9a60baf0224d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4629cef58a560449d42a60be38c13a65094a83ba13886660feabeabe5e23f0ac"
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
