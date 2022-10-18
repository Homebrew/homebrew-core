class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.0.4",
      revision: "cfecfe1a35e9e9d8760451f8f3ca5ad470186282"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e01da9bfc8c422d52e967c31aeed831655d07ec0a635c5d199e72d5458bc7ffe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2df94e6a478c8b0490bbd8f78af221027f3b7635b9788edbacae865ffab8c067"
    sha256 cellar: :any_skip_relocation, monterey:       "73ec43cc85a5f158176baef8154583a968334592db942a0512881f2761b4a3e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd453704896b6b5d15369e4d791d9cccd40a04f5aff04d4e8e8f572ba4e982f2"
    sha256 cellar: :any_skip_relocation, catalina:       "eb8aa48251460a9376f903d344ece6112e12879412548a7f0e5e7dedc1d7ec37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7041a63f68ae76c4d83201a16ed52b16db5f0dd58b827c49b961db32fc524a6f"
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
