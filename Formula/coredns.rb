class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/v1.9.1.tar.gz"
  sha256 "e2181568a8d14147cc1c690dfc2cf560ff1abd0b4e2d65db94c4b9d792390bd5"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e19a786b5f674c2fd9e01af26a26330f3ca5095a5425b7ab6889110692a86b20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be091d7fc9b35c441b3a5463fba57a3292479ec3c6c8476abed543997a30813c"
    sha256 cellar: :any_skip_relocation, monterey:       "a4a3bb091f5f57693c0baa467fd50e204333f928ef95b70d717dab8854eb3a4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bec19d5cd92c1e03c114da0ba90e780abe959aa420e2d3942b333981980b05e"
    sha256 cellar: :any_skip_relocation, catalina:       "a60ef79d782d37b6ed7507434bceccb1c7490c43b62278b291ab8bf6428598be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df42e7bc2c60e92d8d1d46f2b976c5f6e8d03718f9a62259400a5f5358ab7875"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "make"
    bin.install "coredns"
  end

  plist_options startup: true

  service do
    run [opt_bin/"coredns", "-conf", etc/"coredns/Corefile"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/coredns.log"
    error_log_path var/"log/coredns.log"
  end

  test do
    port = free_port
    fork do
      exec bin/"coredns", "-dns.port=#{port}"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end
