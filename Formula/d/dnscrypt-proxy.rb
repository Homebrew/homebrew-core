class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.info"
  url "https://github.com/DNSCrypt/dnscrypt-proxy/archive/refs/tags/2.1.16.tar.gz"
  sha256 "7ba5aa76d3fdc6fbb667689ba13d8ac3e66be27655695a9d412e5ad4afe34f8d"
  license "ISC"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9778cd4bea93d6e136689a9cb0ade6a8941aa5ff4520a4831fface5938bc1902"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9778cd4bea93d6e136689a9cb0ade6a8941aa5ff4520a4831fface5938bc1902"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9778cd4bea93d6e136689a9cb0ade6a8941aa5ff4520a4831fface5938bc1902"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9f6b978cf5a942fb1e3a432801e1dae15a3d07ab84b152eb3cdfe9d67b0e6ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d4156c8c64dab12d46fc1dfc8ffc8ae66f20a77a84184f5c8d9079a856c70c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b01ab18cc5e830362e86696b912314f81f8957efc460804fc15e78eb8bf5f3d2"
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
