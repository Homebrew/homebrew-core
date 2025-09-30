class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.59.1.tar.gz"
  sha256 "005ad4584074ef0952870b13c2b45294b46bad9a10ffb0bdb6d628a28091bac8"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b55e6f55704b525895c4a6dbd9743708c777c56a43e9a48bbfb51138aef61b8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b55e6f55704b525895c4a6dbd9743708c777c56a43e9a48bbfb51138aef61b8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b55e6f55704b525895c4a6dbd9743708c777c56a43e9a48bbfb51138aef61b8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0f855f5fe5b31de270e3a2d5217163a0ad8469a8fcd923808965246d5c09702"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12d502165f0003b4139e5704a94304d6473a9f595af640418850474720612aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90119dddeabf9023a67dd53f1ef490cb1381f35a858e38e7d95df687c280096c"
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
