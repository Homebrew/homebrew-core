class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.21.12.tar.gz"
  sha256 "94ce6f7d015c421ff8b923a46d6c5224547206fdc7d8a1190edb13268fd15515"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubReleases` strategy.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2822aecff0cd2c38f791c9f005d1a434067839e772e9a2deebeab94f2a741e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12ff6ea5db4ca3193ef0c68f793d38c569633e53375715a70e43fd809edf37e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2a1221bf9b9fd537fb88bf86d9137d496ecb8f4647972a90ce2ad3908d4a8a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d33045867755ca22693747d24b92e5e230b8a368828c6fda35362f3a34d04bfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c762db33b7e1d4603a7573ef2180c4150fe8222745fc37f8fbfbd0bd180783c4"
    sha256 cellar: :any,                 x86_64_linux:  "c984cc210f1070ccba0cffd121e43f63e91af724586b1a32db8e9c6b47205866"
  end

  deprecate! date: "2026-12-31", because: :deprecated_upstream
  disable! date: "2027-12-31", because: :deprecated_upstream

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/solo-io/gloo/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./projects/gloo/cli/cmd"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", output

    output = shell_output("#{bin}/glooctl version -o table 2>&1")
    assert_match "Client version: #{version}", output
    assert_match "Server: version undefined", output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", output
  end
end
