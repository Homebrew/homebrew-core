class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.12.tar.gz"
  sha256 "f291a35f82ef9756ed1d952879ef5f4be870f932bdfcb2ab61356609abf82346"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e7d312dfe8bfee71f97e69feb74825da9856e7f66686a3761bbc1501aea7157c"
    sha256 cellar: :any,                 arm64_big_sur:  "6c68b634eb2af452b4561f3cd8eeb5c6b33d9932780a3fced9548517844302ec"
    sha256 cellar: :any,                 monterey:       "246d9fdbe573d1932223fc4169b233a0e671c2a173c17bc663321efd3ef3a426"
    sha256 cellar: :any,                 big_sur:        "3ca31f8a0a9ce8f39bff0cc151e7bf4170e2c70fe56ddcdc85a08f7c3e95ffb7"
    sha256 cellar: :any,                 catalina:       "640996f262c2c0c8e74185ce5608147599f46c29e1cdbfe4fd9e19344422cf5c"
    sha256 cellar: :any,                 mojave:         "67df39d8154409bc39114ff961183b6f4a35bcebe29d4985c317d2ee6990e8dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c068ec1555a37461db9d902c640121eebc7361405719e5dca9daa69248ff90b5"
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
