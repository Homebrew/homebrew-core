class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.42.tar.gz"
  sha256 "50f08b879d4f9d36dea9d905e9eaade15c708e38db7e9a73fc21dc8b45395de7"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "751beaa71e4798579172f4986bc8b866b8af33f12ba5662c044b5d0a90eadd3d"
    sha256 cellar: :any,                 arm64_sequoia: "828bb04c815b3d34c436ab07bc991bd8491e2f44ab682494894d5cb670c7f57e"
    sha256 cellar: :any,                 arm64_sonoma:  "d62ae0381642ef332f90850c8afb675813b7c4eecbe8cbce222ad4dfd17c171a"
    sha256 cellar: :any,                 sonoma:        "60a872a1b7254dc3f5427c81a8966135ab348f340826a19a00d09c60d28e519c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7a2064f6f999f572e9d1b5da8075299359aff70e6ced37780079fa6d550e6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d96e5593198adf4d09ca6edc2a10691f9c18640847be19ac65005f96b8b2715"
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
