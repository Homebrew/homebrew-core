class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.18.0.tar.gz"
  sha256 "2f739a0b5576fd0188f77257744523d930a93aec58ec57d9324daf9dc3d7da90"
  license "BSD-3-Clause"

  bottle do
    manifest_sha256 "58f17d5adf3d49924e8c8ff8368cc82d1659ef400908ef69936d88822deea53b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b8dbfc993634af7097b3f7bc49d2d92427947b89c5101a9f48f4eb2d458c174"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b8dbfc993634af7097b3f7bc49d2d92427947b89c5101a9f48f4eb2d458c174"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b8dbfc993634af7097b3f7bc49d2d92427947b89c5101a9f48f4eb2d458c174"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c129cdce16183c6f0865607b4832d2886f3fc87c60a9a2f9f93764a792f9e41c"
    sha256 cellar: :any,                 x86_64_linux:      "5b87ad61b916f4e058b3a9a21120a2bfb82c8f0f0d09abdd96797593c44063e1"
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
