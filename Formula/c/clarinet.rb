class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v2.4.1",
      revision: "175103ecfbeb9d592640650d25947eeb3a7e3196"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fc7de39c680287f4530a054f259868423626ae6a45fb4d2397ac0a628e01a46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d12fa10a21bffc2ddeb0f70d86cbad9f9f525d5a064b6b0ab865d315092f65e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3283f96a6b9bd4627fd0bc5f10a30407ca29e46a09ab57a9f263507acf3a5ece"
    sha256 cellar: :any_skip_relocation, sonoma:         "c81df84096e068945d3060e4a4a204572b1dd17b7c000892f04aae3856f4373c"
    sha256 cellar: :any_skip_relocation, ventura:        "ff64e3414874e9d69b7662f9d80ab900269e2e5f47918957d6bd59db4da359a5"
    sha256 cellar: :any_skip_relocation, monterey:       "639c78c96f1ed967e84c66a71b8790893850d3a70c775ae45550cd36d5609d7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c6d3de1310a2246073155eb664d3c4758599a8f74ea83236fc1e7295b77bc27"
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
