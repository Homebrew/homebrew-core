class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.12.0.tar.gz"
  sha256 "79e4252e4db4800e885d0f0e690bcf6cb11ffb9a25a793264f42d8eb117df072"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6073eef38a392298336d07f4d5e1ffc785ec1c0ee042451eaff3e0bc698a4936"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6073eef38a392298336d07f4d5e1ffc785ec1c0ee042451eaff3e0bc698a4936"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6073eef38a392298336d07f4d5e1ffc785ec1c0ee042451eaff3e0bc698a4936"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d3f102bb41d3de685fea27a08b64bc48ed1f8160dc9e12e39593b2e237630936"
    sha256 cellar: :any,                 x86_64_linux:      "547750c73440cf6ddd744d156729575d2d47158db1925390836455ebda0d4f9a"
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
