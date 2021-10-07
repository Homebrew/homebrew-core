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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "98cefba0dc7cd9bfff4e1bc263500bfa219994f661ec2237afedf1ac45a52a39"
    sha256 cellar: :any_skip_relocation, big_sur:       "c5f8f485c0604a2303c456117b4ffbaf40009a244424ba4df1660b1cbb285430"
    sha256 cellar: :any_skip_relocation, catalina:      "e59624377389dcb8cbec88b3c99f9f5a320b1d3e7682f3ba37e5a63fc4b9ad82"
    sha256 cellar: :any_skip_relocation, mojave:        "ccdf5f22bb851ff0b21bb55db20e51b5d11dacc3f8e7b2a25d24be80415c44b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffa55179f22ba3f6fed76ce67067396e4c5e49b5ae69f418227d62eda327ff6b"
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
