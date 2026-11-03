class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://aws-nuke.ekristen.dev"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.69.0.tar.gz"
  sha256 "e48733389c9a132e2cb8380ce72d1b7dad07b1a8a08aeda5542e3a31e8bc3214"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a1673acd559a77ae7d810ae72bea906f2e93dabf148a8cf84850d83f26a501f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a1673acd559a77ae7d810ae72bea906f2e93dabf148a8cf84850d83f26a501f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a1673acd559a77ae7d810ae72bea906f2e93dabf148a8cf84850d83f26a501f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d1b846da192cf83d65dabf4b07cceea91c106ac291ab847f8feb370d146fb857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fba0649ae134e72e3769e721a91f2be66b98621a28d5f8605e365d078c257bb6"
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
