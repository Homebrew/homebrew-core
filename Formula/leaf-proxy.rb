class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.3.1.tar.gz"
  sha256 "895057e2424a8b99c2fc330a8b9f34895a377d7fcff5d5fb7b867d357a3bdd83"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "55462c61d114bd612eeadaecae8c9718a2da2adccdda2cea9df98a72fa9dc784"
    sha256 cellar: :any_skip_relocation, big_sur:       "a7882efdf6addbddd3f5f876c6bd74e98b728e80c53d641bb6b8a81880ef3d34"
    sha256 cellar: :any_skip_relocation, catalina:      "1dec02ad9d5ff5a898cf99fd0103305dedccbcb6403acac2223dc77b51e2ca0d"
    sha256 cellar: :any_skip_relocation, mojave:        "939ba81a40b0254a22f7c7db3a99ab2cec706132e8409379636517a2bbe66e55"
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
