class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.5.2",
      revision: "1fffa8a8295256fb8b39d66ed7083269e54cb4d5"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bb3aeb5cdd7f0d491989914e77d0f8e6f562580d4620bba3bb2f850da0a2601"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6f17258ed83e9bb9a3726e5c44f3fb019a3d6c713b68f90cffe6575780b1898"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c85a7eee05c8376a0e2d8754e5c5d5bb341a2a32f1955ec3268602f8cafa76a"
    sha256 cellar: :any_skip_relocation, ventura:        "766fbe689977c2c534aab4d95e8c4cf22b9a6138881595cbc6f6cb97b92ce207"
    sha256 cellar: :any_skip_relocation, monterey:       "fd9dd341b7b20d953f47b560b1b906d4db57dd7560bca1d861ad5f63daf7b94d"
    sha256 cellar: :any_skip_relocation, big_sur:        "94a80b883e2418a70216c3b7e98a8e7a5d9bf2e23761adf0f12611853a7c8de2"
    sha256 cellar: :any_skip_relocation, catalina:       "985e2382ea7a9a51d592448447b005316f7d3b7f9d3270000e0580e3d326aa3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bc83c17bfe7d03f6fb1a6e504d5dbc39566869225afb067a5798becab288bae"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/mattermost/mmctl/commands.BuildHash=#{Utils.git_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-mod=vendor"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
