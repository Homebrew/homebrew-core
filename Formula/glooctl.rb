class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.9",
      revision: "c8aeb75aec47c106f5b3e23329375ff4a0446222"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a0393cf95c26581a0989106ff6f420482bb1fb31a2e18ad42eae6956b0eaada"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d5051d220fddc7036f07e18d70d5e918fa38d0f528f11fbf526949c3cfc0c6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f2ce2797fc221231972a78d45fe1be8c08b77a2d85aaa7ee09c65eb9bec5edd"
    sha256 cellar: :any_skip_relocation, ventura:        "f87cbdd7d8c1df9f09a11527fa7167436e7a61cc32664c5e6b97d14b0f08944c"
    sha256 cellar: :any_skip_relocation, monterey:       "061b40cb34a588294a3851bcb34b2bd61deae31cfebf763694031319e9c7524f"
    sha256 cellar: :any_skip_relocation, big_sur:        "350f0ee32398896c88b52748654bea68dd900725762ae46f9efe4a39c9d24373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6e934193bbfb474a5cedc9b9f23a77144258187f92a96ff4d3ce3d9d9c6a872"
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
