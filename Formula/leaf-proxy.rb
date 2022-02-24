class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.4.2.tar.gz"
  sha256 "7d0e25964f069db14b0d49f83ccb11795d09011162f08050c211cb2320acc325"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "347cbac0d3a894a2cd01717c07968d772c0a86a691281997a96504911f0efe59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6faf8af1896e4ff00c6ded0c6a03947a1b73d9328a218d0fe2f2f9b06ef26b5"
    sha256 cellar: :any_skip_relocation, monterey:       "20110a081b5a55a2c5a048d2ce04c1ea900286e939ca9f2b313ea73051d04a3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e66701f8ff95f577683c03f024edb3d957cd69618d5c372c1740d6947b30ddc8"
    sha256 cellar: :any_skip_relocation, catalina:       "d721ccf00c0980ab4badb76d813814ba8717e24124e26de9d5ae7c29ae66f7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99e42cd1cc81a7a3fdba432445e133de804d6aa684fc8ee11e230e347981f5a8"
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
