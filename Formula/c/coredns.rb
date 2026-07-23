class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/refs/tags/v1.14.6.tar.gz"
  sha256 "44af24bd9ab0b9f85a9feaa3132de72e9e4a0629452d41b3e2f49aa2028233af"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00cf6bbc1340fc961c8e773a703587a03ff9611ee48df6dcfe98ee282b27a035"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bc3a5a605bdfd77b00a5fbecab359910c906c83b08f98462ef5804da66253ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67ebb185253339019754c0620fcf29516a96d4a5106d5b7fdd18ce7eeeb39248"
    sha256 cellar: :any_skip_relocation, sonoma:        "7715de279f24dd47ad9b31ace6835d9e47a9597f126a37b2ce9929351a585507"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b70a2dbd2f4c5873d6f41664399b5830df17e868ac87c2fcc4721db9ed55893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6bccb4706d2539c7995b0c97fc53db3e67b3ffebc2e1e2324de40d2116a6865"
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
