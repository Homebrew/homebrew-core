class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.13.10",
      revision: "7fd876f4e4c92a2aaa99ae8e9774f7a35277cb91"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e933e634c4b0e7201384042f857d344a4c07e6f2ae86e933fb8de83c9580e76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "415203799ce6cb9d80a927ff6ce64684a71dc329048857bacde91db14b58b464"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cca7123d65bc1add25f9e3e311e32526cf00644337413224277a67b6b6ad0558"
    sha256 cellar: :any_skip_relocation, ventura:        "bf4aa348218595364ce3ce201b7a26b758dfa67c869518f3d435af216ec4c42f"
    sha256 cellar: :any_skip_relocation, monterey:       "875109a2b4e556c9ffff0cbf234638050ac0233ea8478b8807c14f66429e5834"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0151be306d78eb27367c81512f3b6ec79803c26249378e55f9e0942e243e9e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e866d98829a35fd0c5eec7845da884a3ea1e9cc086329f3e24a04aced0533016"
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
