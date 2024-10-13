class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke.git",
      tag:      "v3.26.0",
      revision: "5e33e8901f8786f2839fabbbc3bb26086b01fc2a"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "029791a3890dd6bd2701bde6947371e8165491a44efc0b49430b5fb57c315cf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "029791a3890dd6bd2701bde6947371e8165491a44efc0b49430b5fb57c315cf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "029791a3890dd6bd2701bde6947371e8165491a44efc0b49430b5fb57c315cf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1357a775e699d929cdc5d287c5cc1da0581aa96c175588ffd4ace570c5e94878"
    sha256 cellar: :any_skip_relocation, ventura:       "1357a775e699d929cdc5d287c5cc1da0581aa96c175588ffd4ace570c5e94878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "732b925381778fd4f1ad2de44f205741bc6c1200a32d3e4c89ff1fe0124e5443"
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
