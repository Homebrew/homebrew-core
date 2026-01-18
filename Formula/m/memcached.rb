class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.40.tar.gz"
  sha256 "a3d360e9da2221a49bf9aae4e6880f2d44da6b2a2fae39b1911b9ca76488fbfd"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "be7b4c175b369b8180f1fa9ce34af778ab0e5f029d5e4605f74c2ae02bf01378"
    sha256 cellar: :any,                 arm64_sequoia: "6edcd6fca5617f350500cf293ba2a869591668ae5806d5656d4f68a22b0e759d"
    sha256 cellar: :any,                 arm64_sonoma:  "a8c6846df0be7ba0b00316967c3fb116a93f2c06e0f084f32647d9ba3f7704d0"
    sha256 cellar: :any,                 sonoma:        "73966425dd63402998e9f070956e16159d88a59b47f386a48f5c625aa71dde73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d4259b33b573e2b5c64944450f97c62026c80f645a73b68da9b12660ed29765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b206f1adba251a2fa7a7d87884b01517a7b8961a61175f9cef6c8be9094a943"
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
    assert_path_exists pidfile, "Failed to start memcached daemon"
    pid = (testpath/"memcached.pid").read.chomp.to_i
    Process.kill "TERM", pid
  end
end
