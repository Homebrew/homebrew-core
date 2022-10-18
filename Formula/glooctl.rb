class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.31",
      revision: "e6bd43704a02efe11e5c66ae644ce9aea79f3ee9"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a55296cafc1adfd0bfa8d14c77a3d05099605d2c29f92c9acf925d94e3492119"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15d59965a263f7562d572e38b79333ef957c08974436be8d63a77bd5c0407e32"
    sha256 cellar: :any_skip_relocation, monterey:       "644478d59ee4fc840a30e5ae6b527ef26b8d7aa30abeed153d635b52da72ebea"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dc88e96a60a18a1a917c0f5ad91933803fd40366c60237b294ede66350bf239"
    sha256 cellar: :any_skip_relocation, catalina:       "02f965dc22648d227120dec95d2de05b846a1e6a1f702bafb3036243a58986f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa4d729c1e181f200828843e2aca40762c5b2d2804f01c411ddd72dcf2caef62"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=v#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"v#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
