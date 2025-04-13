class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/v0.10.19.tar.gz"
  sha256 "b0a99d43db6551a3b6712d6e905fb0f183d69b7180171d568fe9787c5be31935"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65b11a5b1bfc978a82259903ddb611357c7ee812dd8b97fea46f13b1cf763928"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65b11a5b1bfc978a82259903ddb611357c7ee812dd8b97fea46f13b1cf763928"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65b11a5b1bfc978a82259903ddb611357c7ee812dd8b97fea46f13b1cf763928"
    sha256 cellar: :any_skip_relocation, sonoma:        "e210ac4e25caf14e4a0b32c6297164e078aab6fc64f63b011f461fc8b2d7847b"
    sha256 cellar: :any_skip_relocation, ventura:       "e210ac4e25caf14e4a0b32c6297164e078aab6fc64f63b011f461fc8b2d7847b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fd5339e5e5c6f8a746707e1b9fd03e69697390a9b7fc888a3cce446480630a5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Harsh version #{version}", shell_output("#{bin}/harsh --version")
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
  end
end
