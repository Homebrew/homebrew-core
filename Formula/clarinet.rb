class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.5.2",
      revision: "6b462e251619f9dd9bf908b1a990c4eff134aa5a"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f30788cd1d1338292a1226fadeda2ebd48d15f2a29e209f50392461c72c9f523"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9dfa01c718a71ced9e8b41be603bc0054a52fe22b4311957090f619862a1b9b"
    sha256 cellar: :any_skip_relocation, ventura:        "fed7d50fff171a241cd2435b86adec7df99f92f61b93abc464fb54b9613b6f3e"
    sha256 cellar: :any_skip_relocation, monterey:       "333a65374c7c2db39f70d505f07656dfa3f2928537b6cf171867ff5c87370bd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e16c6eeb58e9513b2c188cc4e200daa1c78bec5bca46d0b47c7ef85a0dc6c39a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d80e1d3e30ce20aaf45f9141ea56a99b1daa2db238eef42116679f247d7b3252"
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
