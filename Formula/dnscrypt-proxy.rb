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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1d5894876e0e8bae1645f3714ca97d537cd02716c15d5929075942072579d9eb"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b8f3028c8227a023d8a017a69768ea5197c2e5a8a764c8c84ed67ba49bf1718"
    sha256 cellar: :any_skip_relocation, catalina:      "062f03c50b960630da46dae60fa7d457ecace41e36b6dfed6b73a0b59c400978"
    sha256 cellar: :any_skip_relocation, mojave:        "0a175c171927e6c8677365e9cb8fcbe4fd7567d66b588d04c1ada9b381558d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81f0cdac5ec5c9ab58e62a4f17e0f0868610e73abfc4e74f5dd32dbc51dbfe55"
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
