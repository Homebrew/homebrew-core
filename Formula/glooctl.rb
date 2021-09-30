class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.8.18",
      revision: "ea05423415d8b026da69a81de98bd29a7f2c3aa2"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a969f3b1456e2377691dee196a54026b03bf34f34dadb33b629985270547a193"
    sha256 cellar: :any_skip_relocation, big_sur:       "eb3d9e0d19781b4a21ecc97ef2c141d01934371bf6403f21bf25daea62b62f23"
    sha256 cellar: :any_skip_relocation, catalina:      "e87dfbf2f543eab86b8d0975ab2666e05f23564779a42a42420a27d18aa30330"
    sha256 cellar: :any_skip_relocation, mojave:        "846e0918b41a814a44d6cec60aabe82f7f18040ad71e92ceec8b0073bb851b8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2665fa82d0fd55680e247ae22151f2d64bcb51c946ddd3b6b640b4aa02e3faf5"
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
