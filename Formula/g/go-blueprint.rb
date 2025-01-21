class GoBlueprint < Formula
  desc "CLI to streamline Go project setup with standardized structure"
  homepage "https://docs.go-blueprint.dev/"
  url "https://github.com/Melkeydev/go-blueprint/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "92d3f157297efeb7f16cba2496ea12e497c3c3db86f751a65597791a5a14a5a0"
  license "MIT"
  head "https://github.com/Melkeydev/go-blueprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe50082e1df32d339bc6a6cd909e0863e1741892cdc48fe46a92d450918d409f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe50082e1df32d339bc6a6cd909e0863e1741892cdc48fe46a92d450918d409f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe50082e1df32d339bc6a6cd909e0863e1741892cdc48fe46a92d450918d409f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a769b69afd4569739708116d41ccc2deed1b177b162c70c8dafe82c72110cd1"
    sha256 cellar: :any_skip_relocation, ventura:       "6a769b69afd4569739708116d41ccc2deed1b177b162c70c8dafe82c72110cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0162d1d554f77b1e9b05c69e5c528445fba9cf694ef52632ae82cb92f973e3b0"
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
