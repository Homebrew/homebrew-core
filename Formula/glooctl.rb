class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.8",
      revision: "80f33d4555b3e3aa671ec5b60caf193dad3e22c7"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7a369cd1c66660a2d038564e11ec885f91103f24ae7020bfb44f9c6c0456cf0c"
    sha256 cellar: :any_skip_relocation, big_sur:       "4d671307f94535b31551eb7d3e8e9a1708a54a711e708a132143164bfebf47a2"
    sha256 cellar: :any_skip_relocation, catalina:      "dc65997a34e7bcdc0ed290ea38eb6fb235f47c9999714139c061109e2c4adaaf"
    sha256 cellar: :any_skip_relocation, mojave:        "b203cc6ae12463b416d0dbc5fecef8813de934140633dfac0ca192d97143edbf"
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
