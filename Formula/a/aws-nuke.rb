class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.61.0.tar.gz"
  sha256 "3a767a76cdd8e451e7c59c51c1593386a2bf5c98438d9313f9cac8d6f584dce0"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e8d4a7e14fc976529d33318f888e5fb12360b2c9b9bf75e66105f469a400207"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e8d4a7e14fc976529d33318f888e5fb12360b2c9b9bf75e66105f469a400207"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e8d4a7e14fc976529d33318f888e5fb12360b2c9b9bf75e66105f469a400207"
    sha256 cellar: :any_skip_relocation, sonoma:        "30f37a8d6ef2e83d4aacd47f65cd2c8d97f7174e4b86c26f6bf65ef0046d7feb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9f12f57d35742f2d130de8b8dd2ecc786fd25c4365731b138e8c84c680b4f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b201e4c32c0e2d114d1475472860cc1526594f6c16273dc2e90e0e5ce27b866"
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
