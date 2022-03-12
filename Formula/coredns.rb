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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccf23c72bbfecb203aae7a4a01deb47b6b11adafba6ac5f3dbca3c5a9611842e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7408440168d9d09e1a78b00d0685710952c6910431e94f66cbe50634830209dd"
    sha256 cellar: :any_skip_relocation, monterey:       "ac89a53c83d37b6dfe40899d9812f9d67c2d34cf8d8753a720247e81d44f7d37"
    sha256 cellar: :any_skip_relocation, big_sur:        "164be13747ee4164564f83837573f302774138fbf8861e85f854d9c42c3935a7"
    sha256 cellar: :any_skip_relocation, catalina:       "ef531be29f53cb27a2c967904d0f42ae3b2c68702c05a892146718d32c564149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36cccd39bc62b9b6160f54ba122cb91e407cd543d577eaed5deb8c661b17997b"
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
