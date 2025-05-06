class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.52.1.tar.gz"
  sha256 "2f8b2f7279113b7864814dbf91d2bd68e01f0dc919df4bd5062cbe4f43f94ef6"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db5b575025683839f266f4d762fc2e75de37d8ece52854a64c448685d8b8107e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db5b575025683839f266f4d762fc2e75de37d8ece52854a64c448685d8b8107e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db5b575025683839f266f4d762fc2e75de37d8ece52854a64c448685d8b8107e"
    sha256 cellar: :any_skip_relocation, sonoma:        "862945bd40b2d0746ef68eed3e7dea30921f6b07b23a6543f325f9246affe86b"
    sha256 cellar: :any_skip_relocation, ventura:       "862945bd40b2d0746ef68eed3e7dea30921f6b07b23a6543f325f9246affe86b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6e3ff75132a8d6efc6798588d7d7021b236a5f95f9782b30103fede68b0799b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84db8000637fe7b93b1cf4a84df4a1ae50eee6344b7bc1fd8bb3a5d2b5e919c7"
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
