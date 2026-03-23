class GoBlueprint < Formula
  desc "CLI to streamline Go project setup with standardized structure"
  homepage "https://docs.go-blueprint.dev/"
  url "https://github.com/Melkeydev/go-blueprint/archive/refs/tags/v0.10.11.tar.gz"
  sha256 "4c5a8d75738fe73266b6e9d051829d7810c3787d52ab4c939c19ca92c9493004"
  license "MIT"
  head "https://github.com/Melkeydev/go-blueprint.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42adecab62200e2165d945a5c3b76e4f6cdec39a6a48e8935f6bbf14d86c16a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42adecab62200e2165d945a5c3b76e4f6cdec39a6a48e8935f6bbf14d86c16a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42adecab62200e2165d945a5c3b76e4f6cdec39a6a48e8935f6bbf14d86c16a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "663fef6abed7598105374838919cf7e37832c6a0ee4b6eec64a9ff6b8277b470"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f1d443b7345a6939245e91d96bca1eb63d704c5144207b2f82f2541ffe7277b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b9d52610b84ad4d63ed527aa5e688980ba56aaa5ffa80bdd0dc5d9c0f132b87"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/melkeydev/go-blueprint/cmd.GoBlueprintVersion=#{version}")

    generate_completions_from_executable(bin/"go-blueprint", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go-blueprint version")

    module_name = "brew.sh/test"
    cmd = [bin/"go-blueprint", "create", "--name", module_name,
           "--framework", "gin", "--driver", "sqlite", "--git", "skip"]
    if OS.mac?
      system(*cmd)
    else
      require "pty"
      pid = PTY.spawn(*cmd).last
      Process.wait(pid)
    end

    test_project = testpath/"test"
    assert_path_exists test_project/"cmd/api/main.go"
    assert_match "module #{module_name}", (test_project/"go.mod").read
  end
end
