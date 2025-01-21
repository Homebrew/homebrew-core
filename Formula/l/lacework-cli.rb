class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.1.5",
      revision: "d9cf374fa558f12e77961967d0bb3b52479caee0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbc11f49daeea15e1e19477e7d77f8bfca83f7955a6d8d7b66b93d487a5bd91c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbc11f49daeea15e1e19477e7d77f8bfca83f7955a6d8d7b66b93d487a5bd91c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbc11f49daeea15e1e19477e7d77f8bfca83f7955a6d8d7b66b93d487a5bd91c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bde6089bd268a90be26ab11c1e96afb543478dd589fd64f19bb05d87474972d"
    sha256 cellar: :any_skip_relocation, ventura:       "1bde6089bd268a90be26ab11c1e96afb543478dd589fd64f19bb05d87474972d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfd8a46115fc32f4cbc8600264acfd4be035a13ec6eebbdb8c1e97c0fadb8d1c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/v2/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/v2/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/v2/cli/cmd.HoneyDataset=lacework-cli-prod
      -X github.com/lacework/go-sdk/v2/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags:), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
