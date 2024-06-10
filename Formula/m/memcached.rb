class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.28.tar.gz"
  sha256 "b1d02d7e9887d80f4885a024931c8bbe9c16d333200d2dcadde8597892c54855"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "91f35254a91ac0e1ec8fec8dd917c8910bb0ae440d051bb2b566a624eca2f4d8"
    sha256 cellar: :any,                 arm64_ventura:  "a6ddc3633b61d1d1e6e395d70d9046b6b40b4316def2133964b220d4c13220b1"
    sha256 cellar: :any,                 arm64_monterey: "4ba0756de58f2bafc7b09710f61a5653d4be13fb789a72fdc77b2e07da7e8392"
    sha256 cellar: :any,                 sonoma:         "04c55d04d53755301a77ce5660c1833c2dc606537a53d28dc22d88fd6dcf5a69"
    sha256 cellar: :any,                 ventura:        "dd3d5c28ce03df3fa4ad82f51cec5c0521ac320bb283f1ad38cc12a3112006a3"
    sha256 cellar: :any,                 monterey:       "02870b0b5bb381162a4bbaa8056d5a128696f55d68b38d29dca493d9c81a1e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9be262dc7bde4a388eeac74c733eee59d9190c66a76ff584c5b178ae881cad1a"
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
