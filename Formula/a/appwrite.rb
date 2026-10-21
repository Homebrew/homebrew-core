class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.8.0.tar.gz"
  sha256 "a35f60a04b067caccae73749a41b8fac813f519487a9016342b900d5277625d8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "64c3eb5d8eebaaa6544465a76167822865cec97dad4684e118fea324c4eac030"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "64c3eb5d8eebaaa6544465a76167822865cec97dad4684e118fea324c4eac030"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "64c3eb5d8eebaaa6544465a76167822865cec97dad4684e118fea324c4eac030"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c06c9ea3c84c152fa24646b4bad37c2d203c350307f274a40581a74ab145201a"
    sha256 cellar: :any,                 x86_64_linux:      "1854553b5bf5692bc63652cedad9531ca3705539c46ea627175e161ac022070f"
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
