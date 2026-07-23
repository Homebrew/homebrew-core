class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.10.9.tar.gz"
  sha256 "ce0ca7b4bad4f608113c90c12a524840cbd870892ebdaec1d84c3abe01facaa1"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "709959697dd33dec42d981df7d5ce217a28f049555dbaac6a1ce0557083382ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c1357a2feb617deb437613f30ceda8cfbb8ced57d6b40b8345dee40f1b7365f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db08fe2f57315d647cf11d6e88b2160fff8362f1903464259c04c0c40b15e357"
    sha256 cellar: :any_skip_relocation, sonoma:        "80a8b6812645a9a7ae6537db0f3cf5c34d88f34392b195cc5fef36ee7948afba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec6b58ec7a06c5044dd41ad1ef8550ec65b18e7e8511e183b14d50aad18acf8a"
    sha256 cellar: :any,                 x86_64_linux:  "6d660720c7016b2b3f882614dc00a29c5a0aa91ade572bd15a98e6a5ef32d2e5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
