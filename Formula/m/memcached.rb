class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.39.tar.gz"
  sha256 "23e5507e933b15463161d4c5d3921b0c5f340b542d6edd7f6c5e17c34f11a363"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a850d1d9911bd38c3f04ddedcbcc0f8442dcf931c16bbbb11e9433992d1ce89"
    sha256 cellar: :any,                 arm64_sequoia: "31337325dcc134bb77d83d33b7f6a3d99a0f9bade5ab749882034851f1761124"
    sha256 cellar: :any,                 arm64_sonoma:  "77963530e4940c64fb42637f6291f756af1ed9aa4700aac5186d624b3cb979ca"
    sha256 cellar: :any,                 arm64_ventura: "552c05a69b61918075ba9db6d67fc3b5638d8c8eca1322f9905366d925f30853"
    sha256 cellar: :any,                 sonoma:        "8576506edee1fcefee427ebd62b1f439f4600d05ad1fe7a370760e47b5265c68"
    sha256 cellar: :any,                 ventura:       "9456e42982b53252e44ae3713f42d73d52d6c14065ec3d6dd4fec66fda5a22fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d2b8d7ca02e02bf98134d3b431381a1988d6f8c71aea024554d97ca87fd93a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce90e5a036314fde45812076c56c18d80805c08e3be5fd1162b56a499e87824f"
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
