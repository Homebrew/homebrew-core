class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.17.tar.gz"
  sha256 "2055e373613d8fc21529aff9f0adce3e23b9ce01ba0478d30e7941d9f2bd1224"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "23cb27638c5132b7cb1695140c220dd91caeb513a390c2b29483b42b1b1cad9e"
    sha256 cellar: :any,                 arm64_monterey: "45243fbf069a4f4316fb8289b60b9e8b9419790fcd0d8da14bb3db2bd6990358"
    sha256 cellar: :any,                 arm64_big_sur:  "ea196f2117f613372a46fc29721ecac4187ddfd03a4a87ae9a513e6ca86989a9"
    sha256 cellar: :any,                 ventura:        "5909cb09ed4e5a23d921a502cad2c860d4e9124d4e60b1d6c0681b3b8901939e"
    sha256 cellar: :any,                 monterey:       "0f50b701cdf195c5f452e14d43b88b48fc17d61d01f9d52072fdd90d25e020b4"
    sha256 cellar: :any,                 big_sur:        "6ba66bec380b965431dd5eb7ede1c71113aa4cc0e1c4ed3e9701c8be44ef963a"
    sha256 cellar: :any,                 catalina:       "6c1ad74d6e75b2661089d75af1dc5bc532cc0fe6012daa851a9d2893afe78a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fabd84f6b09072e8a3f55db66c0416fa72934cc9ab0c10fa9be82f604b3349d"
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
