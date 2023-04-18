class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.info"
  url "https://github.com/DNSCrypt/dnscrypt-proxy/archive/2.1.4.tar.gz"
  sha256 "05f0a3e8c8f489caf95919e2a75a1ec4598edd3428d2b9dd357caba6adb2607d"
  license "ISC"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da74df355890ed829d55080348adc125bf5dfe0f70e0c04c286ce4e65e3b709d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02aeddf862d70235a647e24bc64efb14b29d0c84931d7b2590fe142358bd5557"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93f345adfc058e7ead522d7b2e7a7bf0609475865bf37c9d2238c3fa2ccaf7f0"
    sha256 cellar: :any_skip_relocation, ventura:        "a23dae15ae623b6fe438b911eae117ac87d8d2d866757e527948e5b0bc665b2e"
    sha256 cellar: :any_skip_relocation, monterey:       "8251312fe68d98ad53d4a5edc4c31a34d3d583e62ad5b9b4a6a5b5a63ca9b813"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d4b533f001583fdd3d627ed51b0809e33e5d5318ddb26a0ba0b1da6f6918bf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28702655cf286ac6850f31cafb4d365c12d8b65877d6ff1ace4c1da2795259ac"
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
