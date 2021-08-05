class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.10.tar.gz"
  sha256 "ef46ac33c55d3a0f1c5ae8eb654677d84669913997db5d0c422c5eaffd694a92"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "fbdd2bbefa53d607c9240a758d3a0bfe9509a2c2e58f7d20f91b11ad9b3d82b9"
    sha256 cellar: :any, big_sur:       "f5910b6ea6ec8669064e79e28f8fbcf9f155b016e874dad889816ad7c99f5918"
    sha256 cellar: :any, catalina:      "7a7c30fed3e7578b4274ccdf77da74a2e6810859f07aa5ab5d43f904a9ab6cff"
    sha256 cellar: :any, mojave:        "84357e4c1510a651435e4b662124bb4654cc5427dc0ebbcbd45a70934a509257"
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
      --listen=localhost:#{port}
      --daemon
      --pidfile=#{pidfile}
    ]
    on_linux do
      if ENV["HOMEBREW_GITHUB_ACTIONS"]
        args << "-u"
        args << ENV["USER"]
      end
    end
    system bin/"memcached", *args
    sleep 1
    assert_predicate pidfile, :exist?, "Failed to start memcached daemon"
    pid = (testpath/"memcached.pid").read.chomp.to_i
    Process.kill "TERM", pid
  end
end
