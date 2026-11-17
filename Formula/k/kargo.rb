class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.12.6.tar.gz"
  sha256 "25f8c6ef79c238de24da1fadfe914431fd847c83dcfbd7a01ed7c00b4b291706"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6bc1ac8886eba585e8bbf4a83f29966c363ee03508de72bd752661bc2aef11d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc8be6bcf29cca3c9570c4c51efba47697f5b03742af216e54ff1fee0361436a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "350c25037f8de4850d4f02c928ff2ba5192b12015fcc294377b6500f71034fb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f13701b9e070a2a65719378c279a688aab4229e885593db25530839f0702d2ba"
    sha256 cellar: :any,                 x86_64_linux:      "995b192c9c54841ef9d5603b8aa2ab499e383977c32a8041cc5bb746c25d7971"
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
