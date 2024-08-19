class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.29.tar.gz"
  sha256 "269643d518b7ba2033c7a1f66fdfc560d72725a2822194d90c8235408c443a49"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cc2c11020a215154d9869d8ed0a72099ca0c479af27e59602e04bf2b3a83a91a"
    sha256 cellar: :any,                 arm64_ventura:  "03817796b4845940906d888036834ead2678185707f1e02c4ee71d95d87506f3"
    sha256 cellar: :any,                 arm64_monterey: "cdb9bdbc0da9ed00ec0f9395d4dd4de5c1001dbf71ad1f61127085c4d5c07911"
    sha256 cellar: :any,                 sonoma:         "f843ffb71d0d9743a647903db857c6d1a1fafe7892763f0a201c06ecd030cf5a"
    sha256 cellar: :any,                 ventura:        "419abbd656c300fcf6a33e55944abec2fe9aa03ffd31f595f8bd020805a69544"
    sha256 cellar: :any,                 monterey:       "8320592a6a47000042294a64c7d23bcf28553a6597af71a9cc3da94ca808a0ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1466215ff407ac975a0e4831d5d78d407d50fa3682ca34fc41746bd9af449926"
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
