class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.info"
  url "https://github.com/DNSCrypt/dnscrypt-proxy/archive/refs/tags/2.1.18.tar.gz"
  sha256 "9b810d862ba07c383cc0b8f9f7f1f2ca8f74a02f849d818c4c4d37cc21a7dfa6"
  license "ISC"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa94a5704f3a0e916610c37c1bb155a950c23bf7f890fb2b67db363a31726764"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa94a5704f3a0e916610c37c1bb155a950c23bf7f890fb2b67db363a31726764"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa94a5704f3a0e916610c37c1bb155a950c23bf7f890fb2b67db363a31726764"
    sha256 cellar: :any_skip_relocation, sonoma:        "e36a6a74f7bea3305fc6d3173b6921637017e4f77ba9eb3464f80983e39f778b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8114f1087895df88454540d43507aeae301c8b156da0ad81f9b76cd4af07d42"
    sha256 cellar: :any,                 x86_64_linux:  "1f8798cee558bee552c5c6e4dec0b6af15eb5a01d30fa09a990efb628833b2db"
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
