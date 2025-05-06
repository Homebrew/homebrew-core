class GoBlueprint < Formula
  desc "CLI to streamline Go project setup with standardized structure"
  homepage "https://docs.go-blueprint.dev/"
  url "https://github.com/Melkeydev/go-blueprint/archive/refs/tags/v0.10.9.tar.gz"
  sha256 "0f7d7b0662b16c5ec931e6bfa8bb658a9484727732aa667b19ddddb48830e97a"
  license "MIT"
  head "https://github.com/Melkeydev/go-blueprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1019dc6d770e9e5c7d16905696708291b74643db9ae70c2cc67c12c7eb66679d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1019dc6d770e9e5c7d16905696708291b74643db9ae70c2cc67c12c7eb66679d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1019dc6d770e9e5c7d16905696708291b74643db9ae70c2cc67c12c7eb66679d"
    sha256 cellar: :any_skip_relocation, sonoma:        "643ca205966925bc3bef72b8f840c337d68bd8ed35174e6d53b09193f073936f"
    sha256 cellar: :any_skip_relocation, ventura:       "643ca205966925bc3bef72b8f840c337d68bd8ed35174e6d53b09193f073936f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0625bc19d91aa19567269b23ce82e0a9155d470bd9cfd3fe6a97a06938761e9"
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
