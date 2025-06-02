class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.55.0.tar.gz"
  sha256 "81840be43088bc03d2b9a14b58fc94223f23771acd78daff8fb633c3538438fb"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f4335aa484eea750cfb713b6cdcf7a0216c35bfd27fd3f4f7957abf8e0c7bc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f4335aa484eea750cfb713b6cdcf7a0216c35bfd27fd3f4f7957abf8e0c7bc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f4335aa484eea750cfb713b6cdcf7a0216c35bfd27fd3f4f7957abf8e0c7bc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "001f089f4b8101de6167494b6a0983e014c91d6f3a6b9ff4927dfd453bf1e431"
    sha256 cellar: :any_skip_relocation, ventura:       "001f089f4b8101de6167494b6a0983e014c91d6f3a6b9ff4927dfd453bf1e431"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3844b7527ca74d398a40b9b11f590b6f7e4a1e2f26fdf6743fa8fedf796d768a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "555f0b27862ff5e42e9c3a894f3f66f9223515c6795dd7d00e5515d333c545a1"
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
