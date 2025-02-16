class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.36.tar.gz"
  sha256 "2eeeadbe8ab6c6848654594733e9da4875be7fc870a2c28f651f5bdb4053d041"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4d3fa1393c2e4eb2fd51a10f196477e85a42cbd2ffb33dfada35efaf3794bc70"
    sha256 cellar: :any,                 arm64_sonoma:  "93610676a097bbbb563fe0e7c8cfdb1e789d3cf47aa5965aa512d7a8b39852a7"
    sha256 cellar: :any,                 arm64_ventura: "6f112db291dc2fdf5ea1f1d1916b0c3abfda43e9f5da1ce7e6a53ebb4b2e87f7"
    sha256 cellar: :any,                 sonoma:        "59a8f980fda25eeafc29e65e0594a1d4ad6dc20427b413487d70376395573449"
    sha256 cellar: :any,                 ventura:       "e83be9562eafeaf4142a0ebba5d85573889a6d09ceb834777e2cdbe9947dfbc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5ee95f8c9b164a6be7034ed0fad33059ee73952639d73974657e2e34dbe8103"
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
