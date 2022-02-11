class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.25.1",
      revision: "b2acdc17baa7bbb2f9925b1c5618d00ae3e2d789"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c07b3cbba5d559bcc4f4ee49d74a56f655e8da22a0662a10d7d5ed818fceef1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1bc55363105596a62077540c6d5334a3e15feaed2206d6a3fe865fadc71728e"
    sha256 cellar: :any_skip_relocation, monterey:       "429aafd845cb99554c65b961e9f4a918829103d2dd3777a07169ff2bef4f48f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "03822c10ef35e3083bdc260aa80b8173b417f092735dd808d75eb666ded396b2"
    sha256 cellar: :any_skip_relocation, catalina:       "b2387fda9d9f95b461cc97c5da188349a1f8bb044e67b80bf9cec0fa558e5d9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "445502b636ea1aac07638fb1bb4fe51b0ff387a735e4ff65374290fe1c5d5c99"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
