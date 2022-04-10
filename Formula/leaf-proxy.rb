class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.4.4.tar.gz"
  sha256 "6ce46ba0eb4b357fccc36b3be5bdab32dd6879b53130a496b7a8790a47b14f26"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ed9a5e44c8a66d0d0b44f52ba768b02cc008d6c0889e174b57e83e947069cc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45f843cc561e1915367e6437507abbfb19fd5fb1c2fe61a6d3f929831463fa65"
    sha256 cellar: :any_skip_relocation, monterey:       "b28f5f510b757032f676896edfd7e1f1f2642379a62452829fe688dacd0516d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "2067c5d87f93b52e6de020d2edb2efd4dbf88e81bd07af404693d91b27f838e9"
    sha256 cellar: :any_skip_relocation, catalina:       "730da3df7cc8589f1aa567f8af578c0aa7dff89ffddfb2c00589714f0471dd80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8aa8618d758fcc1d338e842d87a255b8fa61f375ef4aef91ba43e8b140d6bdb"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  resource "lwip" do
    url "https://github.com/eycorsican/lwip-leaf.git",
        revision: "86632e2747c926a75d32be8bd9af059aa38ae75e"
  end

  def install
    (buildpath/"leaf/src/proxy/tun/netstack/lwip").install resource("lwip")

    cd "leaf-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"config.conf").write <<~EOS
      [General]
      dns-server = 8.8.8.8

      [Proxy]
      SS = ss, 127.0.0.1, #{free_port}, encrypt-method=chacha20-ietf-poly1305, password=123456
    EOS
    output = shell_output "#{bin}/leaf -c #{testpath}/config.conf -t SS"

    assert_match "dispatch to outbound SS failed", output
  end
end
