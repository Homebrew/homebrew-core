class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v0.9.2.tar.gz"
  sha256 "f5ac11a49470639d81424b208fc5d95b111a77b97138af7fce347ad3daae8005"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "25a78aafc688dd7fe0b63a98b17586fa55a4c8c991837418070b771336bfabc6"
    sha256 cellar: :any_skip_relocation, big_sur:       "4193a586c388d7c9f5d31e722442703b1060f623a394aad3061f2336e18bf80f"
    sha256 cellar: :any_skip_relocation, catalina:      "9ee00ce2f8a1394401b5892a9e9609079f9983552182772826344c41d660f6f0"
    sha256 cellar: :any_skip_relocation, mojave:        "b886f7e61a7c8f6133e0d306d1377877018e80863aec2de6e2fa4021a7c621dc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
