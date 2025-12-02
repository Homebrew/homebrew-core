class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "63fb0ffef7947dc8602cb362887e2b0b880f10033f66b75f027329c01a3ad876"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb5d8fbfed896b65c29fc454f24895a1269daa6b048ad14b00d3ebbe525ac563"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "019c2d485ab3f1b223b4ac4871aad23648985a6b4778ccc6b13a8a6ee813ecd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e13cc8e9a355ee8c6e76e3df55838dd2b20b42d2a3b767718da8e402aff2e5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1acf61165891d4366ed0012103c3498ec7f4cf5fc76e421b272e8676c484c537"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41af91ec268b6ccb904658bc054c1943391500cbef3ca9c7f15e668f687e7a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23c7bcf363071f5e5d2fc58d876a46759459e768f1c70961c0b29717309240ed"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ldcli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end
