class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.3.1",
      revision: "64baa79541ac9606fc635ad51503b081da505973"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "200fd08a63265397ebd8f40f695ebc874ef5a68be1fb6a07f8297f95a1c68623"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d79cc49ce99ac1bb04b41637204c8eb9f1fcc979631d01720364b1eb5b898d87"
    sha256 cellar: :any_skip_relocation, ventura:        "46dd8d661404120453ab49659aa73c7c5d80a62990253f89f0eb637846de246f"
    sha256 cellar: :any_skip_relocation, monterey:       "686ee5a1485eb03f20a8f7aa188578e2d6715cc486dec634dd744bb558fc181f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dbf13009347fb23014ac93cff5f69cd608e239edaa3dda580a65de15b543b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d91cc73e7ce6b1ea0a13daf036f8c8348674f0748ca198176907d73ddb9dcfc0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
