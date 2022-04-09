class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.4.3.tar.gz"
  sha256 "0a2c5a05c7dcb448c6863f97e61d02b2e8a2095a0d04790ebc14324802cd927a"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "931856a6c0361fe9c48803b8d2dcf66f34d88c3f070d32e4a0528249959aab71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84ea4a852a3c14e9d2149d41236235ecc294241e8b2201a4006b6eac64c41ee3"
    sha256 cellar: :any_skip_relocation, monterey:       "0954b0fd5638a747ba1512df24e0a36b1fd764f33e968f2038e3acac0403f42b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7581f846f0f9f59bddb8d09eb98a3e1011b5556efbb9a4faee5d32e9b868201"
    sha256 cellar: :any_skip_relocation, catalina:       "2739cd2a2245bc2b6a361bd9de8b0f457847214c8c77c138f44b19f448d348ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9958edc844eb18886c230e8f9f627b2bc77fe2e34223e88db2cab18f9f662373"
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
