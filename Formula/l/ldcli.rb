class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "dd16ac7540c4a36a408080e41057f35837b2f9a0a0de65ff235e0fed592e9600"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cef33434c291457c84d533cf6221d4683b540eecda747a7c3a61d7624d03b776"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a782bd186a678f2609b8b73250b8c51894d495fab47449825f57864b826b3b66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b24f863bd46e72da372f9f5157456c75bbde1e7022dbb8b52d5b424588ca689a"
    sha256 cellar: :any_skip_relocation, sonoma:        "18f8a1f6dbcc3349911fdd3a53d591b052e9ff634813848b642fb8ec1e31c8f6"
    sha256 cellar: :any_skip_relocation, ventura:       "bfbe68ccd97df5d74197968ff44f2cee09c09cf0d2345ec106aaaceda9563b25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "674661dd240bd83d67cd5ceb35e31cc7cbc05188835bfba420cbe9ca5084b4f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22fbbe336e9f63e877a58d25cb73af5ac5095e2b9c5674801bfb9506201e4bc4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ldcli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    assert_match "Invalid account ID header",
      shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1")
  end
end
