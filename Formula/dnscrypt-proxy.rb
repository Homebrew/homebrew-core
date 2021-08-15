class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.info"
  url "https://github.com/DNSCrypt/dnscrypt-proxy/archive/2.1.0.tar.gz"
  sha256 "4af43a2143a1d0f9b430f5f08981417cb4475cc590daf79d11c9a0487f72fadc"
  license "ISC"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "16c605c0d6830d94931709cac625d8d7085a56bb68336b79c84bf8bbd95ff99e"
    sha256 cellar: :any_skip_relocation, big_sur:       "9a58ee4594cc5daa6f82bba96abb581fcad384f6704b11c9c79e17607ad6ca04"
    sha256 cellar: :any_skip_relocation, catalina:      "8e32c49eb1a77f48be69ab8acfa172d1573761e96d0136bc847df6c84f7d8166"
    sha256 cellar: :any_skip_relocation, mojave:        "e8c973c0eb72df8b7cb0850c5a7d1d7ced8d811247fc497a631cee612d46e9d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c384b3f29d4795924b082127a789ae698e5037693c0b579badefe48a0866e7a"
  end

  depends_on "go" => :build

  def install
    cd "dnscrypt-proxy" do
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o",
             sbin/"dnscrypt-proxy"
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

  plist_options startup: true

  service do
    run [opt_sbin/"dnscrypt-proxy", "-config", etc/"dnscrypt-proxy.toml"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/dnscrypt-proxy --version")

    config = "-config #{etc}/dnscrypt-proxy.toml"
    output = shell_output("#{sbin}/dnscrypt-proxy #{config} -list 2>&1")
    assert_match "Source [public-resolvers] loaded", output
  end
end
