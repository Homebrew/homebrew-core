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
    sha256 cellar: :any,                 arm64_monterey: "1dcaa5b54129dcc309c8e9aa5eeb5d033c801a813934a5e089cbd414b82ad8b0"
    sha256 cellar: :any,                 arm64_big_sur:  "bd23e157ce3a123eef0c202dd56de402c2ffbb4f4f951942b079f15d25048d96"
    sha256 cellar: :any,                 monterey:       "b8aab839c44f491b0086fac8f6b14507db205dacbc2a848a5ee018f886dba475"
    sha256 cellar: :any,                 big_sur:        "9d17fddea277e6c462a8c3cb8c744f2d8a5ec9cb4deb6bf3bc84ab5ece7b4df6"
    sha256 cellar: :any,                 catalina:       "a414edcafce0460cfa6b266bd1caca47adf78fbb8866c13aae078e394ef5a576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2321eb8f43aed5e6374f2f1a1b1b4709df49bcfbe04d22233abfa08f3e8f008"
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
    on_linux do
      args << "--user=#{ENV["USER"]}" if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end
    system bin/"memcached", *args
    sleep 1
    assert_predicate pidfile, :exist?, "Failed to start memcached daemon"
    pid = (testpath/"memcached.pid").read.chomp.to_i
    Process.kill "TERM", pid
  end
end
