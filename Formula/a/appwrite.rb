class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.15.0.tar.gz"
  sha256 "10a9ee2c244c7a2ec1d426b612afe182567b453aa4a76c1561f9242340459e88"
  license "BSD-3-Clause"

  bottle do
    manifest_sha256 "65c11597e75d604e5ccec59a82e120f4a34990525d88e303d59ca8d28f38919a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8695543266df08af50cbe94fc6b2e7b21c7461c71b0f24845970a328e50b77a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8695543266df08af50cbe94fc6b2e7b21c7461c71b0f24845970a328e50b77a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8695543266df08af50cbe94fc6b2e7b21c7461c71b0f24845970a328e50b77a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a970006d001bfc810b1fb4e7453af71c9afedf413ae0e68f00c646f60646338c"
    sha256 cellar: :any,                 x86_64_linux:      "8db7e32f05b65fe5049820a9d1ea61da2c1a1b405d22c0507dc2cd9cbbf248b1"
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
