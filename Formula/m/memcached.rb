class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.26.tar.gz"
  sha256 "c939c7859a3c1cf60303e9dd080c63ac4a387ee2846d595cd5263a3dcacdc2f7"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c239e788ac8cd186ef666689fe81b35eb49578610f6501e97580eaa360a1c4b1"
    sha256 cellar: :any,                 arm64_ventura:  "b4e1f03aac8a6b3e1a1d0af08e123da28664287901ee72bd6fd15b935e0a24a2"
    sha256 cellar: :any,                 arm64_monterey: "9f922858a9de1eecdd48d32f5fdf1e4a8d314a5e1cc6de79987dda8428cc9fdd"
    sha256 cellar: :any,                 sonoma:         "76cc4802f456c72ed5047bba3b6801c8fad6c24c9db9ec203291ae4bc04497f0"
    sha256 cellar: :any,                 ventura:        "1bc91d5dab154546e73c9b133a434f792a37aadd66c520d16990e5a3bd45a27b"
    sha256 cellar: :any,                 monterey:       "5ebaaa9827bcd369c78470ee4b57654825363e1a0f84e20e567495309b23eadd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f63cc843f552f16aa0f19fd37e37a7f4de85f820536311f1d900c51e8a79903d"
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
