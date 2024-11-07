class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke.git",
      tag:      "v3.29.2",
      revision: "3e7bff60951b8a295aa82f96c57c0151a5a8ceb4"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d20998bf45ff030c8eb3b160ac8a50f1e3a534742014f4cc7b681a40c277fbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d20998bf45ff030c8eb3b160ac8a50f1e3a534742014f4cc7b681a40c277fbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d20998bf45ff030c8eb3b160ac8a50f1e3a534742014f4cc7b681a40c277fbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "97a3d99abbb8f1b5c0fb73a4264fd2ba89021b65c65e3ec600ed77b3e757afd0"
    sha256 cellar: :any_skip_relocation, ventura:       "97a3d99abbb8f1b5c0fb73a4264fd2ba89021b65c65e3ec600ed77b3e757afd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "045d3c41991a927ccf8845f98790ba20f11a1917d9c650fc3f7ea7798626fde2"
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
