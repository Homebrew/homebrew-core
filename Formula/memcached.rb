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
    sha256 cellar: :any,                 arm64_ventura:  "f3050ac0b7bdc618daab73f1adf302b60a6dab5d8cffa7dad540826a4c42a6cd"
    sha256 cellar: :any,                 arm64_monterey: "5b4d33c79448eb7c94443546ce56546bba4c60eaca84173f40f3b120216754b2"
    sha256 cellar: :any,                 arm64_big_sur:  "e0d65f204e332aa122525c4deadf606d45eb90a509769f9bdbab6668857584bd"
    sha256 cellar: :any,                 ventura:        "f62f4d2d51ca6a943354accf79763eb382be172f2b8e4d947d6393b14edb6264"
    sha256 cellar: :any,                 monterey:       "ad5cdfc80d43c5be1fad844ffdb9ec7672ea2394f9fbc517b6b81ee94d9a6748"
    sha256 cellar: :any,                 big_sur:        "471971cee0f8f6912eb7eb566f29d7f6615f1e3e274568889988129fb0e20df4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26334c29676f2ef450d0e3504158c92ac81099c72b5f3a8d9aca77110a9a8e80"
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
