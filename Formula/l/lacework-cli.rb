class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.46.2",
      revision: "8baec422da133932e8ca222eceab03db846db913"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "adb5aa99f30e1f0ad32725e066ce3ec668b8b4fedcfe00d9dc560808a2620896"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6995989e6a6209b13600a473cb17b8d65fe60eafd437bfbf8e7dee8d6d485e68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ef78651f2c9d0198fd45094d2cd5a9bfca9834b94ca6b457ff66b1a1a64c996"
    sha256 cellar: :any_skip_relocation, sonoma:         "a28a367bcfc2e954da43a530e2c4a8b99a8641533cb4ba03f371deabd9ce4541"
    sha256 cellar: :any_skip_relocation, ventura:        "150b9fbd346c2b1a474edac3f04d1be0621442a03961d7c840c7140f4fae2e40"
    sha256 cellar: :any_skip_relocation, monterey:       "91eb8c6f9dfdedbb18d7bccd6c250b68d5584e1e60aa995d52b3417cfb4b0769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5c0360544c3561037c776a19cf0c32f59108b53d4cd774f86d1afb0067cb392"
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
