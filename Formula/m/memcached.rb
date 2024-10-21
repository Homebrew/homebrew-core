class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.32.tar.gz"
  sha256 "4ab234219865191e8d1ba57a2f9167d8b573248fa4ff00b4d8296be13d24a82c"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "87355661847d0e1cd535df12cbeb58010a48413e5047db293ab4f4c34dd2fb77"
    sha256 cellar: :any,                 arm64_sonoma:  "b2a8bd8c8314ae53f869395e29e908586488d4bdb9e9bfd34d9bdf55d6da2808"
    sha256 cellar: :any,                 arm64_ventura: "d1ecc272f88b4f17cff3ab3128a4ba67c682c55fb39d347dd279ba2ed558b90b"
    sha256 cellar: :any,                 sonoma:        "4ff23581f8d4a634af5af50e389b9b91d7bb4cc063577bafdbc58c672647126d"
    sha256 cellar: :any,                 ventura:       "81fa30371ee729dc85148cc5b41edac7024dee83c7b84cf7e78a3c678a943f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6630d97de5281864e089dc2b22d5740a75aa3b60f5909394a156d709f09cee95"
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
