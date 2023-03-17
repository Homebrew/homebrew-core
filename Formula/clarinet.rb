class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.5.3",
      revision: "75231f92d9f76915594e0953c8a8525b823cbf48"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c29ce3bf59ccc1145a186f91987d82ab8656c3cca4248473a04b008d617d2a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caddde7db29a7725b2256a16b43bd0643148a54be9e49a504b0cb31c142dc6ed"
    sha256 cellar: :any_skip_relocation, ventura:        "d72f1ed4868bf6e5a1f35e9779f9d9b13ac0c08f27387b20706a434450eaf967"
    sha256 cellar: :any_skip_relocation, monterey:       "0df8283b220fc8f65412a54c91fa0db1dc441ea19f9c53f5103a066e8c92f249"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec6aaae08c82c02b43ee15fe9c4c962ec3a503076370d0cf45338fba652532ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8622bb752e7c8819c1544dbb788ac301e187f7990e1c40e99e1e3bd15413926d"
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
