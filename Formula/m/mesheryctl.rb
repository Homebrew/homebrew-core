class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.55",
      revision: "daae8594941959cf5e34bb039def99acd9aeff12"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e486953308975fbc07b4a591fa1d4335ada5ced421545ad1048e8aa574f8f068"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "795359fa1401cf51a0cd0ae3f501f71d442150ba8ab8fd1a53e70126e56f6e4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e16712dfc89ac0552dec27cf9d2e0507f642f516893c6d77ea93bdb6eda1c04e"
    sha256 cellar: :any_skip_relocation, sonoma:         "312dcb3ee30cbf0cfa18b80d2fe955b6003593b1c58d8b6710269973cc0911dc"
    sha256 cellar: :any_skip_relocation, ventura:        "18ba4a81ee0af61e268550ff1e6e86d204204c9dd1d8ea66d71f8ea1d979d572"
    sha256 cellar: :any_skip_relocation, monterey:       "df3240ef0171cae4c3d8d026eecb4f17c58de323f3f1d7765d9337f040a4717c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bae7859d8c4332d172d4b1a9a4eeaf9ccfbe029cf9fc7fef27c49e58f972f653"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
