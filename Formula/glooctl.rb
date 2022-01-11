class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.0",
      revision: "7ab135d3b288d90b37e42c78cd70ac203621e113"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9b1e242b8ab41604ca24b0ff6c331f50b7f13efebb362d046b360dbff5a8871"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bfd952a59b5c4620501862f25272abf78f6cb7dcd67b004113bee41ef8040fb"
    sha256 cellar: :any_skip_relocation, monterey:       "4231061922fab3aebce13efa3df7c63bd47d2dd07c0de868ba6c9a655bd889e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "68335cd93ac2c0c7f475ccadaa76a504c8afd2031a607fc7e02a6da452b7ef4c"
    sha256 cellar: :any_skip_relocation, catalina:       "95cd562e86763197248cb5a1c90e936babf62da7b300b7e0b77e20b2bab6b8ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dafa41cec35748688515fe4b838145777bfef96321bf604cab1e570a688d883"
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
