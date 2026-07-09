class Hookdeck < Formula
  desc "Forward webhook events from Hookdeck to a local server"
  homepage "https://hookdeck.com"
  url "https://github.com/hookdeck/hookdeck-cli/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "e869c5cccfb6e37d711add229ea14717516e61912af5a883e31a47588e4f61b6"
  license "Apache-2.0"
  head "https://github.com/hookdeck/hookdeck-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82842652d46c2aa163d214dd0eef4c89979d81467dfd88ec9ee27333f00ba964"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82842652d46c2aa163d214dd0eef4c89979d81467dfd88ec9ee27333f00ba964"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82842652d46c2aa163d214dd0eef4c89979d81467dfd88ec9ee27333f00ba964"
    sha256 cellar: :any_skip_relocation, sonoma:        "927d3b9258f0bdd43ca5d72e44bf6edb5a057ca96e037dde4370438be7889bb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d625c0c4e6415a973eb5eb8fbf38c3a4b3edabdc9bd8ce5eacf65853ba3c59fa"
    sha256 cellar: :any,                 x86_64_linux:  "3b431cb4472e2b08289199d194e95138d0217ac4454c379b1680c3729c1e0f74"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hookdeck/hookdeck-cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hookdeck", "completion",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hookdeck --version")
    assert_match "Provide a project API key", shell_output("#{bin}/hookdeck ci 2>&1", 1)
  end
end
