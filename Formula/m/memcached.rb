class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.31.tar.gz"
  sha256 "20d8d339b8fb1f6c79cee20559dc6ffb5dfee84db9e589f4eb214f6d2c873ef5"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "fd91f962926243534f0e9af72dad004822250b0c826d8a664fa574a38768f962"
    sha256 cellar: :any,                 arm64_sonoma:   "f341416d4fd1a9b9d45383d5f9d30a9fd9b184f0de1cad98178b3fea2beeb622"
    sha256 cellar: :any,                 arm64_ventura:  "ec48c29aadae500273a09c1d4dd34eeaa890cb5d59ff7154af80ca08e5b86551"
    sha256 cellar: :any,                 arm64_monterey: "8228cc2eb13e45ef7c0bdda8e31f7e6679943c9a09864c27a939df00b89bf3f2"
    sha256 cellar: :any,                 sonoma:         "8911ac4f40a4911ebec0fb95a176540cc83858f1f5d990b5583d738b94f0263b"
    sha256 cellar: :any,                 ventura:        "5b63a3b054de11a09cbbe51ecda37494be92604d97fa6618a41c8b6e215d356c"
    sha256 cellar: :any,                 monterey:       "01302f92041974fdcdf20022f45e9435c7681c544b2f0d681f072b83c41dcdfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26a8d8a59e6e9a1a915571871a7b4c85990dde203f180d4bd43c462b33ed7b5d"
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
