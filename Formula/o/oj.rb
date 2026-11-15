class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.28.9.tar.gz"
  sha256 "34aa1fc7dd518ca4a2e7be8bf6e063c3985f941caa3e26c9c56b70102c75efa3"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58f74bb9a9e99b3f04c48d7142fc41d30776bedc74f0c1b5fabf0bc15a6228b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58f74bb9a9e99b3f04c48d7142fc41d30776bedc74f0c1b5fabf0bc15a6228b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "58f74bb9a9e99b3f04c48d7142fc41d30776bedc74f0c1b5fabf0bc15a6228b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cb4152c47bad9e98a6ecff2a6a3529fd3ed7b96822063bddbcb82f4d577cb3e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f46eb478d001caf2964c02c5d0c94b97db421de376aad804bb3adb0430b589e5"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
