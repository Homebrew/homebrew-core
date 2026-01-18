class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "63fb0ffef7947dc8602cb362887e2b0b880f10033f66b75f027329c01a3ad876"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a0f939fb3641a6c986f56f0d671b4842663806c64ac3bf44cd0777cbb7153da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbef86d7c775e2b5a7cbb7f3435447156f67a6d0bde77333296c509270513171"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f3a311fd7b9c924f69f82d180bc76613357f6eebf563e0ee872a29239513205"
    sha256 cellar: :any_skip_relocation, sonoma:        "2785f56a458ddcf40bee06049d40f2f1f52a3156b17edc218fba3bf2f25345ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bb5a8fcf5a8f9312e269404d73681380228881ec8bda1a6f71b80290e12f86f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a5256c8302c101aaa25d208ab1c53d7e7100efcf8cb724449734378413d3f53"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ldcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end
