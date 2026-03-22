class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "ab933ed4f04de3cf377d0ecc8399fa1a6613cecdd7a1c40d90eb0a7471463fdb"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1da7753a8f94320d1bbb065365ad1a02a0d890094d04cb209f784512434feccb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a135e219fcc27a9f3b7b5e8b98f269c8bd9b6e1a0ed4d7c7d01b31ff934fb2c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f738dd87a4b4384b78bbe0a5e10d0b11a4cfa1a9e33fa98fb622f863281d904"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a0a0142119856959a89f535bf3e7b6d0664f46b19120c3b9a3374e991bb4792"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1097610915972b932b1157db5a15c5cd3807cd979f6811d247d6f373e46c4f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed0ac795fba0748a088b65d6068b59eb21ad045cc14b3af2b363ee5330eef655"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "make"
    bin.install "coredns"
  end

  service do
    run [opt_bin/"coredns", "-conf", etc/"coredns/Corefile"]
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/coredns.log"
    error_log_path var/"log/coredns.log"
  end

  test do
    port = free_port
    spawn bin/"coredns", "-dns.port=#{port}"
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end
