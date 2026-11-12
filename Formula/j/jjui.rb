class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://idursun.github.io/jjui/"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.10.13.tar.gz"
  sha256 "f1f68ab9431b1ddb2bd24db68735397167d590d6fcc66035056918b97b283089"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "61b9dcc4b255b85bd64a37f5daa92ea4c3fd6fe257584c2293fa1f32c3010f89"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61b9dcc4b255b85bd64a37f5daa92ea4c3fd6fe257584c2293fa1f32c3010f89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "61b9dcc4b255b85bd64a37f5daa92ea4c3fd6fe257584c2293fa1f32c3010f89"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5b73a72a933b2fd431a556a61fcd95ec42f0e7b140fbc44607ed5d27fa37c1e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9925c7b13b86ac8c619b176e44b29a90c504ab187ddcd6e6407ee1bf244be3b2"
  end

  depends_on "go" => :build
  depends_on "jj"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end
