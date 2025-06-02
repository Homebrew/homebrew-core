class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.38.tar.gz"
  sha256 "334d792294e37738796b5b03375c47bb6db283b1152e2ea4ccb720152dd17c66"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "55e33499cbed86c1a636623339b01d38a157762cd0a22c752ec7ac4ce8b0dbc4"
    sha256 cellar: :any,                 arm64_sonoma:  "e10a0b70add9be90f02ed55ee193e38060e335cbd8c42cf01d75dfb0c70d261f"
    sha256 cellar: :any,                 arm64_ventura: "46db0d5cac37e824195ad729bab7083ece84ffe4811a47f1483f24ec496d020c"
    sha256 cellar: :any,                 sonoma:        "ceddd38dc375d131965565fe18cf33bf9e020377af45b78be2b72b1bfd50334b"
    sha256 cellar: :any,                 ventura:       "83422d1d6f8922a08aff1cf178fd5e421dab23a634501c747c5fb374e52137ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97c6d8b0e593fbce3ee68048853c183ede7c1ae010ce35ab61ce539dc47d50f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "563f4bb84cde98107303ee8a4de6c64f46b5c83fb8f335f62ac3fa8e20615a2c"
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
