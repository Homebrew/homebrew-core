class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.3.0",
      revision: "3980f6df97205434f391bf8e35881ea5330209d8"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a86b16439aeb0510c9dc2941f51771329330787458c60dc21bd1b98e2c93e905"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b488f1adf0ecc97a2734f17b57ab6fd2fda945b0dbab8cfbb534de6e91e32b15"
    sha256 cellar: :any_skip_relocation, ventura:        "3dbc76996c3b3295ddef4093d07d4ce8cbf0bc1e23323de9a11f0dbe28562798"
    sha256 cellar: :any_skip_relocation, monterey:       "7ed5c267446182f70ae53de621a5ce4b24d3db134eedc14b14cc2bae3ffc02a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f374cdc4b0660da39fa371fa245587a9ec14b4bf3c76aa1dd6263f3ee1644687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1419f617825ac0c7608a11b29800846e15dd9cfe367fd23b5e0e31237cde229"
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
