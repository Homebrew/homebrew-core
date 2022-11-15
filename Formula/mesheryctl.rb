class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.27",
      revision: "30e1cef88a1356fd22df04136d32c6ed8017244d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e87a34fc8f9d543431f8d46bee52f29386c8246660e23b616d171895000fd0ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e87a34fc8f9d543431f8d46bee52f29386c8246660e23b616d171895000fd0ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e87a34fc8f9d543431f8d46bee52f29386c8246660e23b616d171895000fd0ab"
    sha256 cellar: :any_skip_relocation, monterey:       "769a83c7f60597ea169d8bb70a7a07ecaedd0339030cd76a599b8843f25b1867"
    sha256 cellar: :any_skip_relocation, big_sur:        "769a83c7f60597ea169d8bb70a7a07ecaedd0339030cd76a599b8843f25b1867"
    sha256 cellar: :any_skip_relocation, catalina:       "769a83c7f60597ea169d8bb70a7a07ecaedd0339030cd76a599b8843f25b1867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eebd5fb2dde971140b3bdffc4ae21a9f48f5f907379d6ac6af116ba0dded0248"
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

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
