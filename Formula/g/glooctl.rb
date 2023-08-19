class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.17",
      revision: "f97d74716971c181da4dd3288612c0b1971138a8"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a419ddfbdda879d28309f0ac98086e8f9b81d2deff0d929b651df357271d855"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca3b5e1269591002a5695060a4aeeab9fd99e5470e674e7c307be3df0ba0712b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9957aca90dc79f0e85c7b79730accbad5a2928cbd3e722a9456cc9526d01e6f8"
    sha256 cellar: :any_skip_relocation, ventura:        "d4f1bb93b8ef89226113216ead54cf21c855afb71af0f53e98afb47460292859"
    sha256 cellar: :any_skip_relocation, monterey:       "a03fb5308008cda45bfb4ff1697d477e51fa0cc4675e0176676891fd5fdb7b9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ba40419c51969fafb8545ef1e7299a4ac51542143a67eedab010a9dc54f5b85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bafc2245cb7ac38a73b06b9fd48ed37a1545f9c73b7e0f0eb830b29d52640b1"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
