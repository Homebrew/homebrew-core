class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.66",
      revision: "9f58d86cb980c326aa6b775360955915a038e73d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c25e29826b9b02fb0cffeeb37e2aae5af5b02f960a803634f1a76e1d1e9af768"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d1c4656c2f4701d7bf9065c449a7a0169c3f1fc3be192c88125e3ce87408c22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cd4cd84884b525b71b574664aa0492fb1fe3b0bbf45e46345e6808052cff21d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2800ed989e34d97de588992bbefc5c49fdd91a99412d0590efa9d48d278880d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7050c1581c89f987e5fd4950a04eac80cffff0b2fcd1eb32b1f96c0f3a6ce62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a19e1182bc11b6c0c748e2e2491200e23f4700f5f0fe70c0186eb6d32fe55d2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
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
