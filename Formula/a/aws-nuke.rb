class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://aws-nuke.ekristen.dev"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.69.0.tar.gz"
  sha256 "e48733389c9a132e2cb8380ce72d1b7dad07b1a8a08aeda5542e3a31e8bc3214"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3720b47878f3d69ed21b46312b4796e87ec86cc262ccaa039ef0fb93cda6ea18"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3720b47878f3d69ed21b46312b4796e87ec86cc262ccaa039ef0fb93cda6ea18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3720b47878f3d69ed21b46312b4796e87ec86cc262ccaa039ef0fb93cda6ea18"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "61e9c00a47b82d55abe51cb3c9a424142f063422749576729b3287dca089f77c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b07f5487c2e5da0e2588a4e6925b7380193fae629d5962c6356463b7a1917ec7"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke run --config #{pkgshare}/config/testdata/example.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
