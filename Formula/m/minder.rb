class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://github.com/mindersec/minder/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "10119636e4ad41cbbe1b3627511a23d14834b68fdb503b23edb07b3a450fe5ed"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26ad770d98c57578261515f56773019ef947a0ac94e222c0555ec39814dc32eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26ad770d98c57578261515f56773019ef947a0ac94e222c0555ec39814dc32eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26ad770d98c57578261515f56773019ef947a0ac94e222c0555ec39814dc32eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "082be64befad832e04a1ec3efe681b46a9bb606db1a3b1e5259ee5529d378dae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32a6ef5b74ae68be6333452d401c53fdaa82e0c2cdf48b9e19a2ba740168bcc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d8373b18ca54c2948d48c49a1961af53320badf80778b891141b07b5f02cb1c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version 2>&1")

    # All the cli action trigger to open github authorization page,
    # so we cannot test them directly.
  end
end
