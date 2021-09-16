class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.8.16",
      revision: "641f96cefbd45f2dd2b9906f5566ea6508f2fb1e"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6d26846a51153b2180e92345725a5a79053283d12eb6a98f57529c00fe194d71"
    sha256 cellar: :any_skip_relocation, big_sur:       "2052db6dfc0db2ca228ba96630bd978649acad1982e0b3765459ebb1b9a3b1b3"
    sha256 cellar: :any_skip_relocation, catalina:      "282478703866a31b9914d2b3aae22a9c4740a9bf34b10d5cde0bbac163acba14"
    sha256 cellar: :any_skip_relocation, mojave:        "9d13152d29d86142234ac1dbb977cd7c96495dee1c2c6320065c2340023f3086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88afbcd4bfc465a5340023fbd2b3686a982bd878f2bb96099fff0bd9338f6f56"
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
