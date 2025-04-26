class GoBlueprint < Formula
  desc "CLI to streamline Go project setup with standardized structure"
  homepage "https://docs.go-blueprint.dev/"
  url "https://github.com/Melkeydev/go-blueprint/archive/refs/tags/v0.10.8.tar.gz"
  sha256 "aaff26eb0c8e3b1be44cd3a4ab3d905e51d0c0618d058ae508d69402e9bd82eb"
  license "MIT"
  head "https://github.com/Melkeydev/go-blueprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2f91622824f87f56f115699459e43b2063fc4202bc43eeb221ecdb4a650c3ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2f91622824f87f56f115699459e43b2063fc4202bc43eeb221ecdb4a650c3ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2f91622824f87f56f115699459e43b2063fc4202bc43eeb221ecdb4a650c3ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a79bfa14d63db0f7dd61db54e11bbebcf32535104fb4a5084c8b61233de1fa2"
    sha256 cellar: :any_skip_relocation, ventura:       "1a79bfa14d63db0f7dd61db54e11bbebcf32535104fb4a5084c8b61233de1fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d66b6c24691974d39a44608306ac2c0cf405789e631288871975fcc5e88bb167"
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
