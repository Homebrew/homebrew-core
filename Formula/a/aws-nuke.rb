class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.63.4.tar.gz"
  sha256 "83e8f1ac805ce69f796b2523b00635eb3268f9dbb99ec867238bc656ad2e569f"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d25d72dfffa23cd71ec12635cc2465edc9aee77eda222527e00f00cbe3f4148b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d25d72dfffa23cd71ec12635cc2465edc9aee77eda222527e00f00cbe3f4148b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d25d72dfffa23cd71ec12635cc2465edc9aee77eda222527e00f00cbe3f4148b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fef7e66cf242184434bccda9979db29343cef2028069d9a11b2d85c430a925aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9526ab46bd4d0470a730e4841feed9f6614eb887db492b80949c6124bdf23072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de1b4a18fe427ecd9d2f5637bd5213339158cb54f620f929613e0828656f4b37"
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
