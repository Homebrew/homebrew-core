class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.32.0",
      revision: "5130661b7aa655bc7082abe87dfcffc7ccc554f5"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7d35ba63deb26465f2a32f900c68ca887a0682df714bd0319fb6ccf345fe0fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e5d41c9e11cdeafda58537b09f1155428df136df31ceb01fb1f075148a42109"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d406e673abfc03990a4c0e1f47ddcd8dc99ac75e6572bad6a2cb5728a8b550fe"
    sha256 cellar: :any_skip_relocation, ventura:        "cc604f2143a8aa83b8529257afcde35315cf12c0efac64276139f53b9ea277ec"
    sha256 cellar: :any_skip_relocation, monterey:       "aada7b4708626472cf178c11dcb3b5863b0e113b8e2b9b2c0916456179fedc2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c628209c21e32aa7a6f9056caa4d20694e8a7d9a55fa1bbae3358da371d7ef72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8897ac730b3a4143c08ca66dfa80f5ce7e415ec376abc985c7c92c9558d45651"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
