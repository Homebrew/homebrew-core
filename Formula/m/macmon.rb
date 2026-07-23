class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "ac8169a4a59afe2a93e033dbf0215682d78a6dddf600398634d0192868787fed"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07d65b8030cc88b1ccce4556e1ac912c3142c5f7670856afa0c0a564721044b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "350c38a37e7a48fd0774f5c9c2260bac0fc1de5d89bb38749bcd3a79485ac562"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d22b7bb986b3d891d0d4ea3cba8f86ec96e9ce4e280be3d39838e9561c22541b"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macmon --version")
    assert_match "Failed to get channels", shell_output("#{bin}/macmon debug 2>&1", 1)
  end
end
