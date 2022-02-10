class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/v1.9.0.tar.gz"
  sha256 "f027926c520e63aa7ec134ea89ca0aac5eaaefef7eeb0e5417e063611de37d49"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3262cc5805a38e9f5efea942bed545f45bb2c90090937f68dbbd67aaee9b8e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa52a3fa6c07ea43fd96af5101ec067141d00f9ae7e0d5e566b235b8f82a40cb"
    sha256 cellar: :any_skip_relocation, monterey:       "e31c46382f530eaac0543a544f9eb3a209e212715956d053023aaa7c25ac94b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba4665f41d1d7b31515263fd24108dffefdc906c52187e28061c14bd65d9055e"
    sha256 cellar: :any_skip_relocation, catalina:       "529c2087a1b051cf1ceaebcb7787c2d92e200fdb14be0c7a47380ce7fffc0815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6452895b9800c0b892d912085e55be3aa44a9d90154cfa272601da0adac2b89"
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
