class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.16.0.tar.gz"
  sha256 "2240fd0a50442d7bb18ef44b784219892be991ceb9c61e424c4170459b2d6032"
  license "BSD-3-Clause"

  bottle do
    manifest_sha256 "31b70b9360c7d9415d340c1c3e40e6dfd97cc718383f037811b385f1ed8b203b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a36f60b79a1c654963a80cd6484c6617d4dc76c82b453efa9d783e9de1674d49"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a36f60b79a1c654963a80cd6484c6617d4dc76c82b453efa9d783e9de1674d49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a36f60b79a1c654963a80cd6484c6617d4dc76c82b453efa9d783e9de1674d49"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1f0305e290168298630abdd71a05b297df9e8e6809616ea7832edf22e83ed348"
    sha256 cellar: :any,                 x86_64_linux:      "b25aa8fb80ea7625ba5a45acfa6bf0dfa658108d36b91a20dd0a1f5f361abf68"
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
