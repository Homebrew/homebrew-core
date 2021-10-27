class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.info"
  url "https://github.com/DNSCrypt/dnscrypt-proxy/archive/2.1.1.tar.gz"
  sha256 "cc4a2f274ce48c3731ff981e940e6475d912fb356a80481e91725e81d67bde14"
  license "ISC"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c5f214e81da7b5f339e8abbe78e386ece9f42c72baf426d13bd08a40cad949c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5db483c47f16ed99a01af92ea89aca4270c8146e33ca0aee4e3172b9960ef7f2"
    sha256 cellar: :any_skip_relocation, monterey:       "aece7d8508b5dcda8746beb38e9d6e854d82f3a5a1231af77479df17e3063beb"
    sha256 cellar: :any_skip_relocation, big_sur:        "66deed2c2da425b2443ac734e61b83cb55d7298179390b6ea3292fdfdca6f703"
    sha256 cellar: :any_skip_relocation, catalina:       "fcc6afc722e5b3dc444c99f253d2424f82e3d40daf27524de03bcee09ec69c8e"
    sha256 cellar: :any_skip_relocation, mojave:         "b83c086949a3fbbe51c4030db4ad3dccc0f4e48ad502eacbe26e4fe4286f4aef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "974f2bf8c5dae80037aa68da36bb66fcea9571a0fa6ebb586cc262df705e28ec"
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
