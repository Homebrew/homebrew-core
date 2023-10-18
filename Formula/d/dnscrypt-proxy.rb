class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.info"
  url "https://github.com/DNSCrypt/dnscrypt-proxy/archive/2.1.5.tar.gz"
  sha256 "044c4db9a3c7bdcf886ff8f83c4b137d2fd37a65477a92bfe86bf69587ea7355"
  license "ISC"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47bd1911bc58efc2b21929d2805ea2b8f59b055b79d852bb3fbeb7c80ec21bd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "288115da2b5dbd3ba90f2d6479dbd1697a6ca13da9bdac901866edd44cea8f99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "288115da2b5dbd3ba90f2d6479dbd1697a6ca13da9bdac901866edd44cea8f99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "288115da2b5dbd3ba90f2d6479dbd1697a6ca13da9bdac901866edd44cea8f99"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bd9b2789f4ce963a4abcd06e2333b1d5350437c0278b8cb25bf8eb8444e534e"
    sha256 cellar: :any_skip_relocation, ventura:        "d520dcc7b0c3183221fbda50ed0847ff0a1fd10f2dbde120ce45e8ab4799585f"
    sha256 cellar: :any_skip_relocation, monterey:       "d520dcc7b0c3183221fbda50ed0847ff0a1fd10f2dbde120ce45e8ab4799585f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d520dcc7b0c3183221fbda50ed0847ff0a1fd10f2dbde120ce45e8ab4799585f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fea5a34cbe6e64ea9163827d9cfbf84b2c415f6f10ecc9dcd1ba6ead3a8a633d"
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
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/dnscrypt-proxy --version")

    config = "-config #{etc}/dnscrypt-proxy.toml"
    output = shell_output("#{sbin}/dnscrypt-proxy #{config} -list 2>&1")
    assert_match "Source [public-resolvers] loaded", output
  end
end
