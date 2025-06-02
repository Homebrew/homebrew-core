class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.4.6",
      revision: "551b1b787fcb838840785f6d4f289f4a2b46232a"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d829e1f2103f30449c954c50bbedf34ff1fcb28a6578e214737f1956d6cdc4c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d829e1f2103f30449c954c50bbedf34ff1fcb28a6578e214737f1956d6cdc4c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d829e1f2103f30449c954c50bbedf34ff1fcb28a6578e214737f1956d6cdc4c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "be7bc031429270ed7d21c266aaf8507c3e807840605151b29bab9224508ffead"
    sha256 cellar: :any_skip_relocation, ventura:       "be7bc031429270ed7d21c266aaf8507c3e807840605151b29bab9224508ffead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d8b0d8a49ba4051f5b388eaa978473d7f1a756ebaf54693fa972b0352342273"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

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
