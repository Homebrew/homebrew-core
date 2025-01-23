class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.1.0",
      revision: "450943d3fd63880d774413efff05a59676507ab9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87b2decd7866550a03a99a43085f43d3cc1f5ff2e9a67012de2776f0704c630a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87b2decd7866550a03a99a43085f43d3cc1f5ff2e9a67012de2776f0704c630a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87b2decd7866550a03a99a43085f43d3cc1f5ff2e9a67012de2776f0704c630a"
    sha256 cellar: :any_skip_relocation, sonoma:        "439f8e9753623d9e4d78919c82213b8cfe56d745ac6cb64af9e50a2304678792"
    sha256 cellar: :any_skip_relocation, ventura:       "439f8e9753623d9e4d78919c82213b8cfe56d745ac6cb64af9e50a2304678792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0f341fae0293cef9f3447384ffaaa113efddb1592776bb57020a0c8f5a652c5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/Azure/azqr/cmd/azqr.version=#{version}"), "./cmd"

    generate_completions_from_executable(bin/"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end
