class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.10.tar.gz"
  sha256 "53263712be6f3462d8410c7c20065ad80362a7ec8750a32b3124ef009c7bbf1d"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3af45293dfc0d3681e5a9b95e46ab76d6407b98c3d12549f6ee86f1a1395d024"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a2421a31d40e0676f7e9040acb743bb0a500e7d2873df3056ea49ff6f6a4a1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2c1a681c645bc46ce0d2c348e676b664a163da9edbc84a283fe34992ddff9c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbdba54b4308e276e674ef1b00bd4b3439e53b3aad990386afbfd9d0b06a2838"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9abcbd53fb4232f6111f289691ac0319ccba46482a25546f08832cae50cb0df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fe2e3fa7af6224e3b07762700661e4e0cd853de5ebda9b8a828676eec36f8a0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
