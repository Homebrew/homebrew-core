class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.54.0",
      revision: "2fdeab69e2819e3fc7e3ff385b0ee975b19724be"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64d62170fb9e7960a8a17403e334ca323a835e09b2a198800c5f1d4aa847a9f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64d62170fb9e7960a8a17403e334ca323a835e09b2a198800c5f1d4aa847a9f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64d62170fb9e7960a8a17403e334ca323a835e09b2a198800c5f1d4aa847a9f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "05249e5bd6f702be4d557a14786c8cad6b79073ce1669bfe281c55bb02d082ff"
    sha256 cellar: :any_skip_relocation, ventura:       "05249e5bd6f702be4d557a14786c8cad6b79073ce1669bfe281c55bb02d082ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a414bfdd6018e48437be671e4aa6275d0ea004ac8559e0f84b0de46aa75fec90"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.HoneyDataset=lacework-cli-prod
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags:), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
