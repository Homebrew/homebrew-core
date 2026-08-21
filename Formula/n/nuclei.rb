class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.11.1.tar.gz"
  sha256 "64c6e21eb8cd141d39cbb0241228fb40fd4370dbe39dc9f13e1069c718b711f9"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8d0c64e09343f95f1afd89c84ad73051931de9ec28648e6a2f0baa492bd65fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06fb27168c496a8b99dc97450369e7c044ac44833b62413bceebcb8bf96e1ebe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eedf87c6e5efcc42bd5f7b06fa2141cd3df9572376da9a28b4e58bed66717508"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1ab57416a2c71a5d940593f8a55d3bfe13cdd918bb93c3db1eb246fb9f6c214"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbe81d5ddca4a68e4255f317d0f8f2e1d92898b534ac97175249a840e6e28ee6"
    sha256 cellar: :any,                 x86_64_linux:  "3856a91aa7ff88a791f7c1f16e1feac256c6ed9a967d1ce461a2bd5a0cb67742"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
