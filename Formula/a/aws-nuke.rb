class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.59.0.tar.gz"
  sha256 "eaedec528520a8a4e3d81822b89a19c9ce2776b78ac6bf04497f6aaf72043004"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2f34fa4d357e5c0064861707e714fb8d50f45b8354133408b2c6b8fc674b700"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2f34fa4d357e5c0064861707e714fb8d50f45b8354133408b2c6b8fc674b700"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2f34fa4d357e5c0064861707e714fb8d50f45b8354133408b2c6b8fc674b700"
    sha256 cellar: :any_skip_relocation, sonoma:        "55da1f97224f4426eb5b8985c35f3bc982acbeba45241fad6e478c668f1005c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8faad0879631274408119cd87646548f74a4a41995b0992da97c3eb41b0df1ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52186e3ccbc53c446673a4614f70f4888484816a6b0bdca52eab9336ca280034"
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
