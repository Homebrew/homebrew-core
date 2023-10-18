class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.22.tar.gz"
  sha256 "34783a90a4ccf74c4107085fd92b688749d23b276cfdad9f04e4f725a05d1ca7"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8b58dd493299e75d92969650b0c510ed844bdbca47985b2852fad428748dcb17"
    sha256 cellar: :any,                 arm64_ventura:  "823b958885742ad41888733ca8a9283be683d6bc226cb5230f6e9447085b9718"
    sha256 cellar: :any,                 arm64_monterey: "135f3036b5e44af36d4596e83205f8d6053d53eddeeac300e137b05ea1415a3f"
    sha256 cellar: :any,                 sonoma:         "fd93ff07164c0ac985de1459abd964731c08bcc25770f4c672c544f179015167"
    sha256 cellar: :any,                 ventura:        "e6ad7eafdd6f8f67c8e8859fa1f33c7b9487fb9d9e562ed8e4b512f66827a74a"
    sha256 cellar: :any,                 monterey:       "027b0f78a808c717c5124ef36288a18b9310df69581a6f7bb3299e4c940de6c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f1e8e2ce0c8a440e47e31e5eac0121ad272aef7e66bf1e2822f37e7f9e21049"
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
