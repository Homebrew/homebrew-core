class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.17.0.tar.gz"
  sha256 "6484be324c7e3a4672729f644216edbdc7a539db695c212840f92fe3d9c3cd50"
  license "BSD-3-Clause"

  bottle do
    manifest_sha256 "4c98d32d0fb4432fc6965f79543cf96dd6b5802decccf28f2256f8aa865bbc07"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77b33d14e69541b90e61906f8a1b2f82435b24326e4dd654cc5bcbe9cd409b43"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "77b33d14e69541b90e61906f8a1b2f82435b24326e4dd654cc5bcbe9cd409b43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "77b33d14e69541b90e61906f8a1b2f82435b24326e4dd654cc5bcbe9cd409b43"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7333f57e6a0de28c8947f5101ef099a9d1942d849c8351d3c42a4cef55ce0477"
    sha256 cellar: :any,                 x86_64_linux:      "d7583f00e6f8f185f85903294ae153d5b206c738e0bc737b0fa9f81fe9d87af3"
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
