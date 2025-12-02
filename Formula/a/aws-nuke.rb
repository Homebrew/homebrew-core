class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.62.0.tar.gz"
  sha256 "42f13a8d53fd20de849d86c7b142a24227c3005d2a68d1a649f0b8bec8858f0f"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed92b66e0c34a9ec567fe852ebd4181d40610a7f36200739567d30e0418006e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed92b66e0c34a9ec567fe852ebd4181d40610a7f36200739567d30e0418006e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed92b66e0c34a9ec567fe852ebd4181d40610a7f36200739567d30e0418006e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "47565ec1d05fd6ab4227cde37fb7b19eba48b1375a33265d34f898cabf91ca82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "917b8cce111e95280678a59c2cafb67da5258850b73bf366fbcac3d25645c7a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "282ae4f9cc805c80a3c6be6f6f91f4f2add82db7a5f4415632502e1a1ab4e9e2"
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
