class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.5.1",
      revision: "f484c59d8b0800a51bad93a4af7016d84884c748"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98eb3e8769f379422537cb16860374aaabd30f1bb4a32cf746a9d5bc79fe95de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3dd7a6c6385c8d53a7352e1522dc2799053c0a13296c6cd8894e6254bb68d38"
    sha256 cellar: :any_skip_relocation, ventura:        "66a566d4fdfa53a5b8ee3e1a7d15cb6acde339f6938f857b5e1d759ef7bc7b48"
    sha256 cellar: :any_skip_relocation, monterey:       "fbff88b5a5e55513c96aafc2c57c0e6f1e6370743b99e73e7f897f4e75c6627a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c4ea0e1f02810a28d311a15a8334f087d4d8566b4b38a158b1a5cdd0fc0768f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4197515b129191b6d64c69cbfe3f896399d823504f05a439214a15b88033ff95"
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
