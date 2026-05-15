class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.info"
  url "https://github.com/DNSCrypt/dnscrypt-proxy/archive/refs/tags/2.1.15.tar.gz"
  sha256 "57da91dd2a3992a1528e764bcfe9b48088c63c933c0c571a2cac3d27ac8c7546"
  license "ISC"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f52afc199f9685dcfe202b307ab4dfb6570079b4ab0138b84db59b3be369931"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f52afc199f9685dcfe202b307ab4dfb6570079b4ab0138b84db59b3be369931"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f52afc199f9685dcfe202b307ab4dfb6570079b4ab0138b84db59b3be369931"
    sha256 cellar: :any_skip_relocation, sonoma:        "adaf7f330014bb1479e5ca2afaa0ce0641d7248327bbf637ef26bb71e928c097"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ee8dd5efa82fd9c23293928ac29b523ed1a4afebacc80b26047c3bea0596edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50ff10c841e16bc412d0d21d18f18a05909f8948a9861100f82b73cbfa0305fb"
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
