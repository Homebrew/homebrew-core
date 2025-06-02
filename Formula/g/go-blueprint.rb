class GoBlueprint < Formula
  desc "CLI to streamline Go project setup with standardized structure"
  homepage "https://docs.go-blueprint.dev/"
  url "https://github.com/Melkeydev/go-blueprint/archive/refs/tags/v0.10.10.tar.gz"
  sha256 "6377012d2899867b5a32f67b810d19cb44b6eb14a3caa8214cb969f69209a51b"
  license "MIT"
  head "https://github.com/Melkeydev/go-blueprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42ef8aece20d3def2f7ec0d148e88534506f6bb6c5cbc978177c6e319fede4b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42ef8aece20d3def2f7ec0d148e88534506f6bb6c5cbc978177c6e319fede4b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42ef8aece20d3def2f7ec0d148e88534506f6bb6c5cbc978177c6e319fede4b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "375fd221422fd06152efbc07380e945a9e124db3ed9709e114b3bc02df735dce"
    sha256 cellar: :any_skip_relocation, ventura:       "375fd221422fd06152efbc07380e945a9e124db3ed9709e114b3bc02df735dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3fbd7863ca7550a48048006c569452d9a16fa8eb2653fefd969545662af74cc"
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
