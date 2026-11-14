class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.12.1.tar.gz"
  sha256 "35de2aab6890962ddede4e3e38eb8cd8372ca707f8e6285e68e8bcf8d31d061d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f5bd4a6810f1b7ce4cb78265c8d5d102e25516c68ba2166f22b5d7f0be1e33bc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5bd4a6810f1b7ce4cb78265c8d5d102e25516c68ba2166f22b5d7f0be1e33bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f5bd4a6810f1b7ce4cb78265c8d5d102e25516c68ba2166f22b5d7f0be1e33bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d94d134eb295044e5c401f699aae8814fb405ccee4dd9242a04c46eb1e2fc9c1"
    sha256 cellar: :any,                 x86_64_linux:      "48718b1b5afb5850ce943548cc7d30f3af1b85e93fb8453703ec72937460db0c"
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
