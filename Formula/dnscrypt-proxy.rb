class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.info"
  url "https://github.com/DNSCrypt/dnscrypt-proxy/archive/2.1.2.tar.gz"
  sha256 "aa55fd52b9c1b983405bf98b42ec754f5d6f59b429ba9c98115df617eef5dea4"
  license "ISC"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3ea6c1b4e59e02b601b6ac4d725823ea9e988fac26e51e11f39c953a5f218e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb685dac6c6eede13db486d13282c119bf65ec1453bf44210db24c9fe952098b"
    sha256 cellar: :any_skip_relocation, monterey:       "53d22657ada544f52117830389f83a3e3a9f5bb138cb0e9687befd7d5781fa8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bcc224c3004a27208125a6c97135a2bc1ee23b7e2254e37c1046d9bc998d418"
    sha256 cellar: :any_skip_relocation, catalina:       "e130425e2c1000396b6b51b942e83a87c44f36c7330d37284111c6101aa67a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "375d96ef3b1a89d3d5f1e5e340b9efc83acbefee67c080629cf567d7a6e7515d"
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
