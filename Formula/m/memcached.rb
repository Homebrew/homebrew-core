class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.23.tar.gz"
  sha256 "85b0334904f440296a685ccfda75f0f4517bf8922ab8efa6d0c4b3c92c354d4c"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b72c509c05d8abf19ad2c0350da031bf2294ce4f69a173c52ac4a5807b0ccbc0"
    sha256 cellar: :any,                 arm64_ventura:  "d91cb8b7fd60f8a74c0271aad7627c25e1e675c9e6af9038d773f0ce25c37efd"
    sha256 cellar: :any,                 arm64_monterey: "3ab822cdd23f65be7b73cd02389e81ec254359901aba5cef8bdb3fffacc2fcf6"
    sha256 cellar: :any,                 sonoma:         "f26572ac7cf36730b8d131d9b62798e9b34d64e546e7ddf66480223fcb70970e"
    sha256 cellar: :any,                 ventura:        "92d28122d392512d8612f9786d4393180655c08e7f9335bae4e1e2610e9d510e"
    sha256 cellar: :any,                 monterey:       "e1766bf19bcf8f65a67c030eaec0d2baa795739cce60628a357f85993a3696e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53f8e9e788976cb23d5d2fa6bb42a945151596bbf27020401da237398eed881c"
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
