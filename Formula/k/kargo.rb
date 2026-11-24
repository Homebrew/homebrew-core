class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.12.7.tar.gz"
  sha256 "4fcec71b3f14fade50b65bf234ec521b2741b2726df763185599172e7bdeceb6"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    manifest_sha256 "adfdcd941799abb25799e0c23e8440abf05d4550b530f9c17c2c7268a7a2416d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab45117eba06c2cede4299aa33c383c95cf0e71eb7341d2f2da8e039aa17fe6b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2357ad2cb950aee6b9241e62c7c1d7a4e7ddd37601c4f350b7bfea4c6827d46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d288b44976d842455196f1a0625d8983bbf30b31b18e4c0c2e447a915f55ae43"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a39c51a062c80ae15cf3a2a776440e639df5a9609cc3682fcfe2b6534d811229"
    sha256 cellar: :any,                 x86_64_linux:      "2171049c8c1fd7f966e59fff3f7a7c0e9d9a396e97d21a448f8c490f9f12b6ce"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
