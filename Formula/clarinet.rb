class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.1.0",
      revision: "f91140d10bd0f7a1bebfed8ce8fbb30093bce336"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33c7ebf7d27944b288dfd75557819fac32562165522e153072e69fb34b6f0afb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76b97ed1c936463db010965810cf2258712809d52255b7efbdd09eb32792b5a0"
    sha256 cellar: :any_skip_relocation, monterey:       "5dfa44d8a0942d57c7ae975bc91af90fd40d42909968a2ca4b574ddfd55d0c96"
    sha256 cellar: :any_skip_relocation, big_sur:        "63b96b2ba3a2ea5d83c4e75ee44bb3436fcb9543b38023042c230dbda2804409"
    sha256 cellar: :any_skip_relocation, catalina:       "317b04d1ceda6b7a41e9c548604055b0f2221e70f99cdd0b4e5b69b4c7cb583e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f5e94f8e4fd2a36282741296dec50886e0f7683ec2b8c497aee17ee7184ac55"
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
