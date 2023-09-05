class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.21.tar.gz"
  sha256 "c788980efc417dd5d93c442b1c8b8769fb2018896c29de3887d22a2f143da2ee"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cc1ab78905c228a49f6564e517bbcb3be54000e76d783d8127e9b9779aa4be0f"
    sha256 cellar: :any,                 arm64_monterey: "57119b41b85fe6a0186fb673378aecfccc10d2209ac14dc44387e3b58a1d7a9b"
    sha256 cellar: :any,                 arm64_big_sur:  "44a0aa54ce84212a71eb9812f476d6c9747253e4bfef6952bcdcb45e0e340cd1"
    sha256 cellar: :any,                 ventura:        "7693b1ab9d0a4ffe29e8c8459fcd018f08212a996d7d337fe31478d894c039f6"
    sha256 cellar: :any,                 monterey:       "ebd2e253fa9bb28e846ef072e00c5b6ebb1ef191d800a675dafec791d94b9eb3"
    sha256 cellar: :any,                 big_sur:        "8a3c748a9bd1b918b7b29a6759af7ba7c1e6e2aba499d6966e35adf5cc5c1d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb6962039b1ac6b1ba933ab0be65a2dca3a993814c7c6732d01d96cb3ad5a837"
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
