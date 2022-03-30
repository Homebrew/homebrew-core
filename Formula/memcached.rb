class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.15.tar.gz"
  sha256 "8d7abe3d649378edbba16f42ef1d66ca3f2ac075f2eb97145ce164388e6ed515"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "13e199a5e625e5d220a97d9dd81b3aae92a9e1b2789f2b8808bf0a92552399d9"
    sha256 cellar: :any,                 arm64_big_sur:  "52de67ddacfeffae6b8c04eb77a59fe4e9d82b5db91ada4a6dff57571c2d39b0"
    sha256 cellar: :any,                 monterey:       "ff2d94b15d121696479a10766ebbc266f70a25579d462b90e6492a7662923033"
    sha256 cellar: :any,                 big_sur:        "d4802ac7f1f821032311c9b43318e1772392bad8ce7ad238f7ea055b9deb00a6"
    sha256 cellar: :any,                 catalina:       "fee345a6df836633cbbeff528889840e4e65739876a7d82f4c65dbb28a6b3b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "744ae187aa87e9c18867bc3db06f469f3689e3d10bf7350553158c95c9d11eb7"
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
