class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/rebuy-de/aws-nuke"
  url "https://github.com/rebuy-de/aws-nuke.git",
      tag:      "v2.21.2",
      revision: "e76d21c263477ebd6648fae19f9e539049ad2b51"
  license "MIT"
  head "https://github.com/rebuy-de/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f2d0dcf1b1092ea82be2ce8caf96ab4cc2546d2956fdd59083039e8bac2e516"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f2d0dcf1b1092ea82be2ce8caf96ab4cc2546d2956fdd59083039e8bac2e516"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f2d0dcf1b1092ea82be2ce8caf96ab4cc2546d2956fdd59083039e8bac2e516"
    sha256 cellar: :any_skip_relocation, ventura:        "48b4bf2b7a42ae9324875e7954d1e7432f587baa1dce3209afff5893ffe25487"
    sha256 cellar: :any_skip_relocation, monterey:       "48b4bf2b7a42ae9324875e7954d1e7432f587baa1dce3209afff5893ffe25487"
    sha256 cellar: :any_skip_relocation, big_sur:        "48b4bf2b7a42ae9324875e7954d1e7432f587baa1dce3209afff5893ffe25487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc8814510dc2141e6b8e4c049bc90ec40c2da11658eeea8261b370d18e6f577d"
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
