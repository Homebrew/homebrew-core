class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.info"
  url "https://github.com/DNSCrypt/dnscrypt-proxy/archive/refs/tags/2.1.21.tar.gz"
  sha256 "8427c2d3c16a0509db89abaebe7a4390014c7e5919290d5dabef8130c5ff7019"
  license "ISC"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "8a01bdb59602905b0970c2d1cb9f35c2fe09be571032b78396cdcd8eb913cadf"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a949f2a103572ba6b6a11937c11ff377ccbca07a3404ba617dca63cc6ca488a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a949f2a103572ba6b6a11937c11ff377ccbca07a3404ba617dca63cc6ca488a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a949f2a103572ba6b6a11937c11ff377ccbca07a3404ba617dca63cc6ca488a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "77294bc45d233e4ff7819becce7dc3361cb765911354c9b6676330845a9d1b85"
    sha256 cellar: :any,                 x86_64_linux:      "1cd284d20dc71f3958f7779031fc6466dca572cf77da7bca69b9d07aff2cda26"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download", "-C", "dnscrypt-proxy"
  end

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
