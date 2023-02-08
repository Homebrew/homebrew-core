class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.4.2",
      revision: "29cd1d9f896beb023623c4df5f91762b7950eec3"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d9a4cbaad47a8ca112aa8b393dab3d0eb6d783acb3f909ef1548b5c74f3f935"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37947f3ecf6a0afc2a1d5e33e7a601d2ce28e12cfc8d8a36f5b5edd8fbf02641"
    sha256 cellar: :any_skip_relocation, ventura:        "f18a68b958c7f880536348cf77ca0b3195eb57a471ea9acb69232deee8e7f55d"
    sha256 cellar: :any_skip_relocation, monterey:       "419e23058b3b3a8f7dcd3a36d82d06cf125dc29bb59d53cf97e830d89b1c407c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5241e83de61ad10dd06a4888dc1b040ade24dc5f3316d42a1a5c758238e2b94f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3f834fe82235ce93a1ff6cfd1ccf98f7798ce1f71a7f0b0ff29ceed2231fb27"
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
