class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.14.tar.gz"
  sha256 "54d63742c6886dcdc4e0c87f4439a2930a876cd9f2bfa01d699b0c6bad1707b3"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a6a8fd0dfe19188ea6e42fc750c8ed3a09ba34b3bfa80694fe6c1a398e051763"
    sha256 cellar: :any,                 arm64_big_sur:  "01603a7f7791ced3c8271e0e036d19dbea9afeb39e75d6b057af4c058521da31"
    sha256 cellar: :any,                 monterey:       "0757348fb5c89a131dbe3a9b8dee3b76a2341bf6a264d5796d480969a20e8ddb"
    sha256 cellar: :any,                 big_sur:        "632a9163d97df61899d84e10e7dfceb788fbe5da01a2147a445b07288b7800b9"
    sha256 cellar: :any,                 catalina:       "d09725fb66e581866a8e7a996500323d6781b1390fd4921b876c546a9e28e390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27cf32dbaa1858fd5d595dff3c706c448cdfb6406b42b11dd136ac8c0245ae37"
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
