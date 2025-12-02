class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.info"
  url "https://github.com/DNSCrypt/dnscrypt-proxy/archive/refs/tags/2.1.14.tar.gz"
  sha256 "495c4f494d40068e5e3ddcb8748d91b90e99f2516060e3b59520b9f3d6148a9e"
  license "ISC"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f777ca5ee453c1a5f540bd82e96e44aee0ac723a6e0ba27d259bb36ad66e2e2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e68f4297462c1d9d0c5a6078d876641084bd0961916d2276bda880d96d94e45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e68f4297462c1d9d0c5a6078d876641084bd0961916d2276bda880d96d94e45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e68f4297462c1d9d0c5a6078d876641084bd0961916d2276bda880d96d94e45"
    sha256 cellar: :any_skip_relocation, sonoma:        "061e8693a4aa2def40b855840df9fe0f57616e4a31f8cb7ca2e945154ef5033c"
    sha256 cellar: :any_skip_relocation, ventura:       "061e8693a4aa2def40b855840df9fe0f57616e4a31f8cb7ca2e945154ef5033c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab1f408921de8d4100a9fe9bc7cf38074c5e5c4b32d7599e6c4d03781918e15b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba761961d8e3f2905c54f0fd0ee8367ae19a77b09dd9701d787d58854972f0ee"
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
