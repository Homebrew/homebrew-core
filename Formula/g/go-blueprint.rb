class GoBlueprint < Formula
  desc "CLI to streamline Go project setup with standardized structure"
  homepage "https://docs.go-blueprint.dev/"
  url "https://github.com/Melkeydev/go-blueprint/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "f2baebc7d77203e69dd5d39adbe68c1eb89e142e243e5f9f019203b84a84f4cc"
  license "MIT"
  head "https://github.com/Melkeydev/go-blueprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95a00e28301d6c5a4147caa3dd6ffb30b3ed899747804e3f485117459c5c111b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95a00e28301d6c5a4147caa3dd6ffb30b3ed899747804e3f485117459c5c111b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95a00e28301d6c5a4147caa3dd6ffb30b3ed899747804e3f485117459c5c111b"
    sha256 cellar: :any_skip_relocation, sonoma:        "070b742df0fb47aae49d28bbc553d6de9d1a442ab743d9b2001ba1e61a273b23"
    sha256 cellar: :any_skip_relocation, ventura:       "070b742df0fb47aae49d28bbc553d6de9d1a442ab743d9b2001ba1e61a273b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d58242d8f846c1d813a48a30ee170fd56f9fb9fabb567bb7f0044a0a71c0282c"
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
