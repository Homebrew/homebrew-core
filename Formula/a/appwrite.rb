class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.11.0.tar.gz"
  sha256 "a6e20c19b068f262538b0837d89dd3e537b3e5c42321c5cf7307bf501911364e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b9a89abe19b91c68e8d3b3e9d68da5791b30bddfda0e11c71d57e81e5057aa1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8b9a89abe19b91c68e8d3b3e9d68da5791b30bddfda0e11c71d57e81e5057aa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b9a89abe19b91c68e8d3b3e9d68da5791b30bddfda0e11c71d57e81e5057aa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ae02b4b91db6900057f05f10b6ad5cbcc73eca6473b240ed5b9e2cb308407a43"
    sha256 cellar: :any,                 x86_64_linux:      "2ebc28f2aa937aa08c859bd30d0a8525cdbf9bddab4745a2ce877ff9eee3ee2e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    # `go mod tidy` needs module metadata beyond what `go mod download` fetches
    system "go", "mod", "tidy"
  end

  def install
    # https://github.com/appwrite/sdk-for-cli/blob/4399a3321898f40cf982acbd4859d506c9d4d9f4/.goreleaser.yaml#L19-L22
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags: "-X github.com/appwrite/sdk-for-cli/internal/app.Version=#{version}")

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
