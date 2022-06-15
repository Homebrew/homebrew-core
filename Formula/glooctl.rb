class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.15",
      revision: "bd20dfcd222fc720cf0a4f9569477fb1bf4a4469"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b4934f45ce20a3509c94d894dac2f88870dfb618e1990cca5b24914711d9551"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b67ef5ef1ac8cec281abbf489cb79c962f685a14a1c7ebb4bef2591b0f262070"
    sha256 cellar: :any_skip_relocation, monterey:       "21e6b635489626c717c0d60902be93be6a8e604878eefe1b347f9c9f8c147196"
    sha256 cellar: :any_skip_relocation, big_sur:        "8062778c7990cf9a6b0358a367536371e1c0a70d31a46fb9f3e8d227e99b3dee"
    sha256 cellar: :any_skip_relocation, catalina:       "60654ffc06702b1b9595b8a97fa778d5b583b82d750437b7a61600b305f3123d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be8e2e183f3003026af9fbffc1242d9376bea05f61dcbbc86e4d96f94424d893"
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
