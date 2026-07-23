class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.62",
      revision: "79d1d1c0b5844bd909086913856298cca3e2f185"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1090d05895f1ca8a26853523b8a4b2bc5152cbca6145504b4c41500d3b465c3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b642bea723e864daeba9ca04160b885b5880ebaa1a94e7cb9882055c579d698"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e29abe81a1b38b34040fa7c19ea9dee2f677665e689480c8c5ef069240804a2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "577f03c6f5015d6645f4d44529cc035e83f3a2479a5763216124f94a98edd771"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1e5835295951d7eeb5fae3ca06ea001efa977c18e662d9e440d4c1161eef9c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d610db207a8a2cc2121dd2ee08864285a2b0cd17330ab0640ede0c75bafa7607"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
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
