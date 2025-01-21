class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.34.tar.gz"
  sha256 "0d5380e2e0a5b4fcef1d89a368a11c4f06686c6017c1fff778b3b4578f0674ec"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c998df28aa1dc2c6ef7ac394333fd1d7109647eea6cfb1e0babc65d7a462c2fd"
    sha256 cellar: :any,                 arm64_sonoma:  "795b4feacaf53ca0016ff8ab65bd69ded715eec8037659f9893fc2ccaf992a11"
    sha256 cellar: :any,                 arm64_ventura: "4a37c50edb4d425471441783a89554b61624c2950937e33ffcd762c07c53a79d"
    sha256 cellar: :any,                 sonoma:        "77c30a2e56d6c34a611eab9e155a428d285e8a16bb7aac0096d072926ea8da20"
    sha256 cellar: :any,                 ventura:       "42ef2660d8bc01c19d4409f042b469eb6ddabb68b7ce6c5fe865c0b3eabc02ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e8a9186e60ec24da4b5b7e24689f4eedf1dad91d873b9dcb899165cb2d8923c"
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
