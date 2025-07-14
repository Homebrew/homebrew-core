class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.56.2.tar.gz"
  sha256 "d43ab2e77994e5c9ec19651d998624cb9e68408dc0fa31aab2e6e830910f6fde"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "105469d3f53925908e03a64036ebec65c1e716e30175ffc13db1159bae69a55a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "105469d3f53925908e03a64036ebec65c1e716e30175ffc13db1159bae69a55a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "105469d3f53925908e03a64036ebec65c1e716e30175ffc13db1159bae69a55a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed3ca3a072681260466b067569769e708d23c9fe9a5e74fe451c9988383164f2"
    sha256 cellar: :any_skip_relocation, ventura:       "ed3ca3a072681260466b067569769e708d23c9fe9a5e74fe451c9988383164f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12358b18822236b3ba9e238d9804e9a5d65b5824b6c8d34349276d43bccf21c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "022ce63a421ffc1d5b3aef7f7007e26b9cfdb5b472be612bad6cc23cec37108c"
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
