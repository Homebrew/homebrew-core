class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.64.2.tar.gz"
  sha256 "561b99817af5487be87316151aff70cf177fba8ff7d15ef41d7616a1e0b7a91d"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19b0b4591857896e0a00466161c71bf7c1afb356021f961cf23b0733f357441a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19b0b4591857896e0a00466161c71bf7c1afb356021f961cf23b0733f357441a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19b0b4591857896e0a00466161c71bf7c1afb356021f961cf23b0733f357441a"
    sha256 cellar: :any_skip_relocation, sonoma:        "12cef9c71c9261d628e22bc44f93e5b9c499ce6479a3fb67b8b2d98b7a0cca71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e59af915ab625b3e91bc1c1ab9c68c40941064930dc2d9836baa2db82c51ba0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf21af196c6c97130f9f6198cc41d9de42877a62fdda328710d25f00df783144"
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
