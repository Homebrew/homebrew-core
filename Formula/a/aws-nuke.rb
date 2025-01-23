class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.44.0.tar.gz"
  sha256 "24d7565e1ecfe7d19a61978dcc5722d11857f381c2719f3358f59030903b3a8d"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f5c28c5f61a08fda4f0a9ac1263e1220c8f194dea00091dd0ecd866131a738d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f5c28c5f61a08fda4f0a9ac1263e1220c8f194dea00091dd0ecd866131a738d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f5c28c5f61a08fda4f0a9ac1263e1220c8f194dea00091dd0ecd866131a738d"
    sha256 cellar: :any_skip_relocation, sonoma:        "baf86e3e510e4e27f98011fd79c97ef690a04928501d029f57efb24cc32ce4f2"
    sha256 cellar: :any_skip_relocation, ventura:       "baf86e3e510e4e27f98011fd79c97ef690a04928501d029f57efb24cc32ce4f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32b235fbc536d915583e97de6667f8a89b0b2cf46675656f9e3aa0181ab7bbdb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", "completion")
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
