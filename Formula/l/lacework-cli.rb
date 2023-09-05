class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.30.2",
      revision: "3883dd5752feda8ce8fe896d543ed1cda0362779"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a7189427d81c734d510ee9843de5b9259c1986e04e13b414869c88aed223bff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f4af7208c48e78bf14cc842215b6398e2dcc4b4bd425623fe71a06f6c1f097e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c21e40b91474f7ef3e6cada52238d7e9e5f999430a4c95b7a0cc724afd75d55e"
    sha256 cellar: :any_skip_relocation, ventura:        "7ffd09dc6bfa6e233d83ff4d92a5a789092902da3b2bc2ad8ca1223fca49ac9d"
    sha256 cellar: :any_skip_relocation, monterey:       "11cb94aaac4a3d9593817b306750430b3bcbed48de8c2d4335e0fb5644c750f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdfa8e8c705d95e5ef44b4956027d413b9ad80b3328fdc284bd85eb98828f2d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5188d9d6760c888944137e24de896bc00f0782a8236d5e9d61380c6528c2b4b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
