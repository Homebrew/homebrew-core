class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.11.0.tar.gz"
  sha256 "a6e20c19b068f262538b0837d89dd3e537b3e5c42321c5cf7307bf501911364e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e191e1fb6c3a97778a3540a4cf7a94f9f2041ece8b0de62e51b39f1e34cc0291"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e191e1fb6c3a97778a3540a4cf7a94f9f2041ece8b0de62e51b39f1e34cc0291"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e191e1fb6c3a97778a3540a4cf7a94f9f2041ece8b0de62e51b39f1e34cc0291"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c84ff01155cab265ca8e0a756471ca17cec9ef56c821f991850d0fa61134dc26"
    sha256 cellar: :any,                 x86_64_linux:      "02be3f14902a60e861c1c9a8d103e086c6acf130bd577a48e5d2ca74e0752fb1"
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
