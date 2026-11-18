class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.14.0.tar.gz"
  sha256 "c43b83d51196c5bcb03f71e9d2f6d9a2e53887c8e809390f941a2b56b4d21eed"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6baa18b8b3b10b534364e1596fd22d7afbf3723d6b76d7b5c5816938ce62d4bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6baa18b8b3b10b534364e1596fd22d7afbf3723d6b76d7b5c5816938ce62d4bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6baa18b8b3b10b534364e1596fd22d7afbf3723d6b76d7b5c5816938ce62d4bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b0322c9342e06b9d19a90e21fd943ae68bf2f76a766366df784aa3399ce029ab"
    sha256 cellar: :any,                 x86_64_linux:      "70b6a5f5f5ccad8f5282c2645321a66f90d365c2aceac92417ef7e76db3b4c02"
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
