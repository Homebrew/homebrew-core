class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "b64e0c5970000595a0682e9a87ebbad5ef0db790c1b6efbba6e341211bdf3299"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ee283878fabb27f7d0a91edcbe72791caed6bc506ba212d6e4a8d26aa78f5cf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf5b0564bb91517b2e73fef4f920f3712a8a902d0929414682f8523f70d4068d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4865306d9d98472dddf23bde124d4607921e5d4e5d1c1ed180399be52bba0286"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51eb12aeb879dbe70d6aba4ab06acfc27ba326ab7d9bd4d48aca078b3bf5fd00"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3556d21f2d4a6fc7eed891898ea75db3f7b16cc19243c89a553c04e1d565a5a"
    sha256 cellar: :any_skip_relocation, ventura:        "99e2ec11717e4fe0c63cf19121bf51c375831f259ccbed9079d68c50faa2b87a"
    sha256 cellar: :any_skip_relocation, monterey:       "68202f59c255bf02654473774addd8d83af716591c5a210a27815b7f67774a2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1d4a5cc01e1e87f94f20e725a17c1ec387d2970dd84b845b3625c60bac29b0a"
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
    fork do
      exec bin/"coredns", "-dns.port=#{port}"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end
