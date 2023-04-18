class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.19.tar.gz"
  sha256 "2fd48b047146398b073a588e97917d9bc908ce51978580d8e0bedaa123b4c70d"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c197952d03a0448fabd17debcf5c9d42038474be7bb9002f2f3bcda9cd9a9ee6"
    sha256 cellar: :any,                 arm64_monterey: "ec9d04d21a4f83c9ab07d5a2225c2124ac490b9d66a2b34aa307066d1e8448e8"
    sha256 cellar: :any,                 arm64_big_sur:  "6bd7ab5896defebd8626a247c104d07b4e083cc0fb2bace4b21123258a935b19"
    sha256 cellar: :any,                 ventura:        "d0fc6100bf1082e4bfdfa414c0b92bbafadcdda522da549047d3a28c746bc29d"
    sha256 cellar: :any,                 monterey:       "7c465e4ded6bb806e34ea3f18d444f9c91854f1638446aaa3887e9adc66403d2"
    sha256 cellar: :any,                 big_sur:        "85930faa76c898c544fb9fc194fe36e03a7886936074f003c3f86466ecafd630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6df7ff74546690fcd03c9922032c1ed6d8c38dedc5712b94f5b6829600c2056"
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
