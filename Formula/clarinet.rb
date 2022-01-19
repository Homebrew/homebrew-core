class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.24.0",
      revision: "066b4e9d6da55b6f4d262f432a8e1f92490568f3"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d43c947340d4884b9ac6dfe753c9dd84967323db1094876e2e18915e098b077c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef44de0894f043f456a47b6f9a4def6b5e300fa549d3d0a5fe1d037693c5e544"
    sha256 cellar: :any_skip_relocation, monterey:       "249d4357c099596b7367f44688a8b6dfd22701c5bd89c6117dc1c7157a6507f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b299b3b92bcc65100bf944af4827c6d35170d2c5d0908f470fa3b929fb96d52"
    sha256 cellar: :any_skip_relocation, catalina:       "7821ae2c8072c0d4909d6103cdcc646a7b0518833a7fdea5859a55b71726a56b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8425505ef557f4d9be5efaeefa422df5451990b94f63d7a627fce7ee48d7b011"
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
