class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/rebuy-de/aws-nuke"
  url "https://github.com/rebuy-de/aws-nuke.git",
      tag:      "v2.20.0",
      revision: "8062fc7d7a4b62772f6d0835aa6b0e46322fa288"
  license "MIT"
  head "https://github.com/rebuy-de/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a76eb92fdc7b43eec7768de8179200cd63b6cd35a316b8403bb664673a3f820"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a76eb92fdc7b43eec7768de8179200cd63b6cd35a316b8403bb664673a3f820"
    sha256 cellar: :any_skip_relocation, monterey:       "11e96567908e330c5aa577ed5a892e9f0846415fe10145b25a93b52aa37a525a"
    sha256 cellar: :any_skip_relocation, big_sur:        "11e96567908e330c5aa577ed5a892e9f0846415fe10145b25a93b52aa37a525a"
    sha256 cellar: :any_skip_relocation, catalina:       "11e96567908e330c5aa577ed5a892e9f0846415fe10145b25a93b52aa37a525a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "940fa58d60e8a4e5e934dc6155ca4b9ef58b2c98fdaa19ee04d59756274991db"
  end

  depends_on "go" => :build

  def install
    build_xdst="github.com/rebuy-de/aws-nuke/v#{version.major}/cmd"
    ldflags = %W[
      -s -w
      -X #{build_xdst}.BuildVersion=#{version}
      -X #{build_xdst}.BuildDate=#{time.strftime("%F")}
      -X #{build_xdst}.BuildHash=#{Utils.git_head}
      -X #{build_xdst}.BuildEnvironment=#{tap.user}
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    pkgshare.install "config"

    generate_completions_from_executable(bin/"aws-nuke", "completion")
  end

  test do
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke --config #{pkgshare}/config/example.yaml --access-key-id fake --secret-access-key fake 2>&1",
      255,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
