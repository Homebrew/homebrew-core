class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.info"
  url "https://github.com/DNSCrypt/dnscrypt-proxy/archive/refs/tags/2.1.8.tar.gz"
  sha256 "db2d593d084d034235faaf09743318b4039fb5be2d3a6e17cb0157091d23f4db"
  license "ISC"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91e4c78e3601aab2a1f8e50217260da27d501d7b0cf13858d063c7b278ae95b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91e4c78e3601aab2a1f8e50217260da27d501d7b0cf13858d063c7b278ae95b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91e4c78e3601aab2a1f8e50217260da27d501d7b0cf13858d063c7b278ae95b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bc6a5fdd903b3d15717eb20446c9e59ba54f6e03d16e9c5078795c82896c9bf"
    sha256 cellar: :any_skip_relocation, ventura:       "3bc6a5fdd903b3d15717eb20446c9e59ba54f6e03d16e9c5078795c82896c9bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8957c4861f3297da76902a9a0cbe729aa71882662b683ba65e3f012b239537d5"
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
