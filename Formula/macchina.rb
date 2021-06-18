class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v0.9.2.tar.gz"
  sha256 "f5ac11a49470639d81424b208fc5d95b111a77b97138af7fce347ad3daae8005"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c7d83200c0a892f600487054b4d177c85565db88c3086c5213456ad621ae74a4"
    sha256 cellar: :any_skip_relocation, big_sur:       "07783179d4fa09142731337bfc4cf053b64daf6d1062fa9b822d7cf5ab4af401"
    sha256 cellar: :any_skip_relocation, catalina:      "556670ff3ebd99d5ba897cb634104a98b74e3c23aad6e99113bb7c08a130da2f"
    sha256 cellar: :any_skip_relocation, mojave:        "163c3c266eb2112acc0535827ca55f73467a59ca9e68f808805bebd360773760"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
