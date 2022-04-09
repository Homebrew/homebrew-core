class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.2",
      revision: "435c134f3fa21d6f894668be4ac40098d6460188"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7290453f90fa4e13d36cfd663953288eee21f8b34d1ecc58e07775d81df4d94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b31d5ed237691a6b6b25c7aea91e52e2a4723a3fc0f4de0744f77343a995a674"
    sha256 cellar: :any_skip_relocation, monterey:       "3bd0bc25a40ddaba39594ac5a320984297f12607a3e3babaa0b253512c730019"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b2059f66b4c1bc6ed4332a3326987c04837dbf88435d3c4f9a9f4112a3dce2e"
    sha256 cellar: :any_skip_relocation, catalina:       "08e3cf503dd5cfc8b9af400c58632963de4167e1c8950ee9c349628e2ef86d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "910988645f3cbe318afcf3e0f4d3d50303cc66b4d141c09f2947cad2f76b5932"
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
