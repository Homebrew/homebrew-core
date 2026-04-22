class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.0.4.tar.gz"
  sha256 "8b450fb2a65f90ec6302b29ee38057943eb88b30c0d5c42167d52da84f66ad67"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8c360ff53602d02e7f5649ff6f813b45ef0d820c37cb4e1037525e57a0e54cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da856eef3b51f18541712dfed76fe731cfc115ab2f7867fbae05e457df4098aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5de1690f4625d2d842a7c8d67de8ae8d9c1b40f50ae4e7a9d16243b18cc2b8bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "951e01fa630b3de43dd245a7ac5e03d64070db4e431220e2e862a60e4cde5140"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d06fe9a43c6461b592efeef3c36e4904b99a81e85b15a71b74933df9a9ca9030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df74f3d537d35e56bba8dcf7309a2925c3cd7b461951103ff3c0c86b9c2f80f0"
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
