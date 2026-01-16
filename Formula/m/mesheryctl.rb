class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.197",
      revision: "55b78e0bc4681ef332c5f5c2d8cd39968e68daa2"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7468177f308bd02e7a4b6e734c979f3220986513a8d1e8575b090a71aa5a483"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e53dae9a9cda497d16e1363557643cc04b6e4774a8d28c0dd7e045aa80b1ba1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1abd57d5eb4c2c64000432fdd24b85d5feeedc460b83f2adb84df6a2bf01127"
    sha256 cellar: :any_skip_relocation, sonoma:        "815b460aaa5e69b9d95ebb7ab2bfac86d782e89c019c55ed1b87977b0a6efd4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17060ac2827252995a4d3ade56280414fe445bf7f1e058a4783e563cbcad5926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acde8c6b6b3bd99532e8c5de4961d53a20b66f9087791863fb1cc04236249b6b"
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
