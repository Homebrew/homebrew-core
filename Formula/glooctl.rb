class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.9.0",
      revision: "9a50ad4e0a9383f03be228ef628022eeb5253c94"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b88ed0d35e8c1aa10a3e95f3c085983d695089d12e42a582337d063080e463ef"
    sha256 cellar: :any_skip_relocation, big_sur:       "fbbdf5dd721507e006d4ac8183013c8382c236e6b029a8f4fc65a274b895e5a0"
    sha256 cellar: :any_skip_relocation, catalina:      "6e9dbfd9b01dc084c1527fc78d0a5186e4eee67da4aeb82627e319c9625ecb3a"
    sha256 cellar: :any_skip_relocation, mojave:        "a32e3c7881f95c1ceaa9158aae2a654170e2b610ffc41602c580f1cfed4c96c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "651ca2fc65694f0d939a7a7f7c6595296f91f27d09bfde0df130564e3fed2a94"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "TAGGED_VERSION=v#{version}"
    bin.install "_output/glooctl"
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
