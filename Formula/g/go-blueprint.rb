class GoBlueprint < Formula
  desc "CLI to streamline Go project setup with standardized structure"
  homepage "https://docs.go-blueprint.dev/"
  url "https://github.com/Melkeydev/go-blueprint/archive/refs/tags/v0.10.11.tar.gz"
  sha256 "4c5a8d75738fe73266b6e9d051829d7810c3787d52ab4c939c19ca92c9493004"
  license "MIT"
  head "https://github.com/Melkeydev/go-blueprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "518ba176f2365fcba2c62d4f7953a95e576248b7254c69f88a02a61754396c7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f9ef29a931115b5b44f61bf4cc1582fa48fde680e05f0111634c216e65abd66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f9ef29a931115b5b44f61bf4cc1582fa48fde680e05f0111634c216e65abd66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f9ef29a931115b5b44f61bf4cc1582fa48fde680e05f0111634c216e65abd66"
    sha256 cellar: :any_skip_relocation, sonoma:        "98b590e460f2a77c655783bf7d3a12d2228ea8e8a47a0b70cd03ad1b110f8e10"
    sha256 cellar: :any_skip_relocation, ventura:       "98b590e460f2a77c655783bf7d3a12d2228ea8e8a47a0b70cd03ad1b110f8e10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67d5c270678754708d5eec5561d7b24dc4ed928c638a60548e72ea28466dbd98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0bb3805c4152579c6b594374b5aee19b00271b0caf8b2465fe5cded05de73a8"
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
