class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-10.1.3.tgz"
  sha256 "2ab0a784ddb4f70b2d8f4c1901fd564b3c3c5c3f872588a8a3c2fe3ad1dcd6d3"
  license "MIT"

  bottle do
    manifest_sha256 "eff8cbfdcaeb4da08604b15f7cd543241e95efc11c55f5b1e1fe6d0d0dfb1258"
    sha256 cellar: :any,                 arm64_golden_gate: "37568a187d3ff22c3be0a765f89d6652f84fe36535032ded64310d339c1ba34b"
    sha256 cellar: :any,                 arm64_tahoe:       "37568a187d3ff22c3be0a765f89d6652f84fe36535032ded64310d339c1ba34b"
    sha256 cellar: :any,                 arm64_sequoia:     "37568a187d3ff22c3be0a765f89d6652f84fe36535032ded64310d339c1ba34b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9b1e72741a58456e30d97fd2142390fffb268678008ae9bf9850fc4c3f6bf134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a42640c75b0787a697227955cbdf18502b2a0dda6f74f71a7ff8500e44e065d7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
