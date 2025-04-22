class GoBlueprint < Formula
  desc "CLI to streamline Go project setup with standardized structure"
  homepage "https://docs.go-blueprint.dev/"
  url "https://github.com/Melkeydev/go-blueprint/archive/refs/tags/v0.10.7.tar.gz"
  sha256 "24a3b3725afad41ed724af4f460b5dc502e2169f03ee5a826fc46a7c404fc1a1"
  license "MIT"
  head "https://github.com/Melkeydev/go-blueprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e2809778c71838b79fbcba6eff8e34b01b28eb7c6a00ff88f6a389e00fd32ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e2809778c71838b79fbcba6eff8e34b01b28eb7c6a00ff88f6a389e00fd32ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e2809778c71838b79fbcba6eff8e34b01b28eb7c6a00ff88f6a389e00fd32ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "f97759335828a8908ec2804d4b3a43954abfb225f32003bd90a80f03b7b67a70"
    sha256 cellar: :any_skip_relocation, ventura:       "f97759335828a8908ec2804d4b3a43954abfb225f32003bd90a80f03b7b67a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2068007acdf35e674dbdd254e96e4efc05442b251c9aa0583a0a8a53a362e120"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/melkeydev/go-blueprint/cmd.GoBlueprintVersion=#{version}")

    generate_completions_from_executable(bin/"go-blueprint", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go-blueprint version")

    # Fails in Linux CI with `/dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    module_name = "brew.sh/test"
    system bin/"go-blueprint", "create", "--name", module_name,
               "--framework", "gin", "--driver", "sqlite", "--git", "skip"

    test_project = testpath/"test"
    assert_path_exists test_project/"cmd/api/main.go"
    assert_match "module #{module_name}", (test_project/"go.mod").read
  end
end
