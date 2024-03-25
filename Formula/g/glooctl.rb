class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.16.9",
      revision: "85aea1e3b3a43bd937d0dc75c50f5f4624f9698b"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae52c4b863ead30680b4f0d75810d0ae2bab4d067a55075c5775c934839ab6fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d631d0f4d01852a3f6194b566f55aa100080df90e524aa14bed857ee4cb7197e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9798203de9171cb92d17df394ef8afdbe3ce8ecf5ed4387defe255fe61b9da3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8e1480498931b045a5fcdacdb6977353fb7c71fb59f72b98b64d49d43116726"
    sha256 cellar: :any_skip_relocation, ventura:        "49ae3c30c160ecef4bc714c6827f2d1dcacb20462143f75fb875e76f79198e6d"
    sha256 cellar: :any_skip_relocation, monterey:       "92d740282136d564109658ed7b5b865b684b4cd6a03e89ee6b8c0e5ef780a8ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01be203ac177f718e635cb1be7286720bdbef4a9ca060736d697b86a3ae7afc2"
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
