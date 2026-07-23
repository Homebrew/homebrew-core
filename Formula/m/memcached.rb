class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.45.tar.gz"
  sha256 "d362c64e6d8d5287153501eabf7c85b4a761432fbf53f5d7b085d0bb1653c1dd"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "68e37be8e89af4d756d69cbcc46334f310bf4865d4d0f70bebf5db16a3a9c3db"
    sha256 cellar: :any, arm64_sequoia: "63862e6cd5e5f3d7f146a8d7d05e29be08943ff2efee6364d759604c63024904"
    sha256 cellar: :any, arm64_sonoma:  "60b574b8eee009f0332f3f9baddbd00ee050f19126c5d69a356fda88f40b8d72"
    sha256 cellar: :any, sonoma:        "0addce6ba648a7e617ceb0efe5e7fae7309e20a6c2383905c44faed13e42d48f"
    sha256 cellar: :any, arm64_linux:   "55341142efcfc8946468e3cf6765d29fe0e3c58e661a7e53bf04a745ab3cdea5"
    sha256 cellar: :any, x86_64_linux:  "3b54b11a1b8f0edc671ab50c1a38a6b6c224e2b806ffce1e097047a9e3ce802b"
  end

  head do
    url "https://github.com/memcached/memcached.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libevent"
  depends_on "openssl@3"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-coverage", "--enable-tls", *std_configure_args
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
