class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.41.tar.gz"
  sha256 "e097073c156eeff9e12655b054f446d57374cfba5c132dcdbe7fac64e728286a"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "73994b98ba41eaeee0e79d4b5ffab8b9fb68856d5e9136148f1aee6b68cc151b"
    sha256 cellar: :any,                 arm64_sequoia: "21d44b6b093e0d4782e28cdb4972521e06a7d40a56648a07ca4e228c5fcd2726"
    sha256 cellar: :any,                 arm64_sonoma:  "12a9038a6a0ce0efe49f915a5c869dd6d22841fad7ea5d2a7a95b8632110d154"
    sha256 cellar: :any,                 sonoma:        "9014d9f2c632c4095b22a05b6476416bef77993e8ccf7f79bc81560d5e2bb21f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59ef13bbcea7a66128350ddecb643619f3d1c9e616fc43d82634f5d341048410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e3fd0efd8dd876cbfb403902908c66b28af041d665b6acbf41f5cfd9ee7ecf2"
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
