class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/0.12.2.tar.gz"
  sha256 "31497b249f2c7e32dcbc29b8ffd13748e7720a05bd48afdf15ab4c5fd917c60d"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f080c1a050b0a037ebab378f8bfe7f74a9c16b1b5100668a7337a3060ac49653"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f080c1a050b0a037ebab378f8bfe7f74a9c16b1b5100668a7337a3060ac49653"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f080c1a050b0a037ebab378f8bfe7f74a9c16b1b5100668a7337a3060ac49653"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e5761951d6f7269edf4b4929d2209126422a8c4a7e7bd0a0eb6dc668850db69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28c9d77c9a5ff7d44b69b14d5fe430bd8e22ae7f2d8662d13e8dda379fe81507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b68990f52903233a1bb076a0dd029dccc1da3d75c8eeedf5a96a831ba51d4824"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end
