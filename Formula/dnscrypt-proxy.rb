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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04609f0aeb13b73574197ddae82002b70767af27a143602957416acc3528b53e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6dd8e7322e75e63b81bf558e66bd9b2fa9d2dc057e0e91f49b0b82cd71e145c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "798fe4fc473052faeeac10acc35f70917287f42926898feb5a923a44a22bee1f"
    sha256 cellar: :any_skip_relocation, ventura:        "4f7fddcecd63fca271973bc770c7d5ef72936a64e51fec3455e5d72ae9525005"
    sha256 cellar: :any_skip_relocation, monterey:       "1bee7e7150bdee4d4ba2596c6a8d105811a45937dc616b7ec344b12793bf53cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8d9a53880d1ea0bd01e1f09f0a9d6fdea6c94b83e507490ce10d7e5e12a1e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "362e0584724fa8fbe907833186acdd09ed2c9b7cbde86998b0d64baf2354a869"
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
