class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.64.0.tar.gz"
  sha256 "f3dbfcd155d53503bf2764b51a9e631a158fee8d5ba697c3d892e80cb899ca2e"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "235dee769ae5050b94b6f649b068875a832cfb9a68c6e55704ddbcda779f68b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "235dee769ae5050b94b6f649b068875a832cfb9a68c6e55704ddbcda779f68b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "235dee769ae5050b94b6f649b068875a832cfb9a68c6e55704ddbcda779f68b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "993d9805bd79e3093e03e662ef9701aa2653c4efe3cfda96f9bde8fc66319dd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4490f5cfc3370f3cc04ae17028165a3a88fba56cf3606d6ca9d723f114199c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2e7df2f20fbd07c7b270f3674915cf1c57531aeee1bce2e9caf425a192c9943"
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
