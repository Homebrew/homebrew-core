class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.info"
  url "https://github.com/DNSCrypt/dnscrypt-proxy/archive/refs/tags/2.1.5.tar.gz"
  sha256 "044c4db9a3c7bdcf886ff8f83c4b137d2fd37a65477a92bfe86bf69587ea7355"
  license "ISC"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ea768229408e91e1b08f306acd6d792af62769878cf1b698db8685eea45e05b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ba1ce4730b6a4cfc8c9bc0dee6673fa4976fd93210a9cfd0bda31cf323d7788"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1347d13d9ace17fc3ae034f12a3accff227cc6ae72a25a10981456fbd6de7d26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed1192dffd1484ecfb6a5802a4e09ad00a16f5d907a09399cfc4132487ad8265"
    sha256 cellar: :any_skip_relocation, sonoma:         "378fc9e369a39cd6a5274b8a6b61fecb9b409b36730aa1b8458fa7af78fe9495"
    sha256 cellar: :any_skip_relocation, ventura:        "c27f790ca8f3e0c04b6f6cfc5fc0ccf7527d1e3447bd8728f15398731c008e19"
    sha256 cellar: :any_skip_relocation, monterey:       "3624afaabee33cee1775589243dd20a6dfb9191bd5589d1a650ee3ee95d660e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6deb6772518d34e6845e043bf3eb00bfc4831d7a2a422156cf5ba50388b88297"
  end

  depends_on "go" => :build

  def install
    cd "dnscrypt-proxy" do
      system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: sbin/"dnscrypt-proxy")
      pkgshare.install Dir["example*"]
      etc.install pkgshare/"example-dnscrypt-proxy.toml" => "dnscrypt-proxy.toml"
    end
  end

  def caveats
    <<~EOS
      After starting dnscrypt-proxy, you will need to point your
      local DNS server to 127.0.0.1. You can do this by going to
      System Preferences > "Network" and clicking the "Advanced..."
      button for your interface. You will see a "DNS" tab where you
      can click "+" and enter 127.0.0.1 in the "DNS Servers" section.

      By default, dnscrypt-proxy runs on localhost (127.0.0.1), port 53,
      balancing traffic across a set of resolvers. If you would like to
      change these settings, you will have to edit the configuration file:
        #{etc}/dnscrypt-proxy.toml

      To check that dnscrypt-proxy is working correctly, open Terminal and enter the
      following command. Replace en1 with whatever network interface you're using:

        sudo tcpdump -i en1 -vvv 'port 443'

      You should see a line in the result that looks like this:

       resolver.dnscrypt.info
    EOS
  end

  service do
    run [opt_sbin/"dnscrypt-proxy", "-config", etc/"dnscrypt-proxy.toml"]
    keep_alive true
    require_root true
    process_type :background
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/dnscrypt-proxy --version")

    config = "-config #{etc}/dnscrypt-proxy.toml"
    output = shell_output("#{sbin}/dnscrypt-proxy #{config} -list 2>&1")
    assert_match "Source [public-resolvers] loaded", output
  end
end
