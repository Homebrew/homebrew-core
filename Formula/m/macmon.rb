class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "f613c7e1b395a68e696b8f2ed82a0157cae87215b91e429e15c98f5a9662076a"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "371881f2d351ce3291309b4997a61943566084f478ab7913396383268042efcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "557ed23d9ec407e15c4253544a8b1ddff3c558b4dde2fad45d4eb9ef9cb48b42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f883a324def10d1dfa421af6f46826ea73bd8f81d6919b4eec4da70bf3cfa6c"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macmon --version")
    assert_match "Failed to create subscription", shell_output("#{bin}/macmon debug 2>&1", 1)
  end
end
