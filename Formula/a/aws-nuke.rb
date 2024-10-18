class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke.git",
      tag:      "v3.28.0",
      revision: "467d1a85fd4ffcbecae48cd63777a2627d39da95"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f3bb31f31a2c03a0af40468197598d68398b842afb5507c4c93ca8d2e25b7a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f3bb31f31a2c03a0af40468197598d68398b842afb5507c4c93ca8d2e25b7a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f3bb31f31a2c03a0af40468197598d68398b842afb5507c4c93ca8d2e25b7a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "688122f3653c1d4e9edcf7cce87f980ded2c19e020047eebc5a0d0e89c981de8"
    sha256 cellar: :any_skip_relocation, ventura:       "688122f3653c1d4e9edcf7cce87f980ded2c19e020047eebc5a0d0e89c981de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eabac30b6dd4d6cba9f9255ccad78ebddcbf7e1ec715aa61cfd0b11b86c80aa5"
  end

  depends_on "go" => :build

  def install
    build_xdst="github.com/ekristen/aws-nuke/v#{version.major}/pkg/common"
    ldflags = %W[
      -s -w
      -X #{build_xdst}.SUMMARY=#{version}
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags:)
    end

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
