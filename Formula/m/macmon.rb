class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "ee99781d0f1a58d21e802acaa7f5850a8a43935c86e71158dcbd07b30ffcd941"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7884846f0ee48efeb5c5d4efeb24af65e9da9148ff5deb85aa0ea4bb4ccba07b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be1817c0edd78736907ab09b7fdb06d911888902bd81e5469e2c95f6dfe3a1a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d63c7021e07432567e2509e3d79ea6999f35a0b3b2fea3cb1e7494a7be9d72d9"
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
