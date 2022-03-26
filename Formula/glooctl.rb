class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.18",
      revision: "2ef965da75862ec63aa9f9eac2c46de2f8455d03"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3758061774d20145889f26486599a70bd779155e5c1a260abea59530e609cd48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfbeec2bfc73544d072480db198fba1e56ca25873ba6d803bbc9d7e5f0d3effb"
    sha256 cellar: :any_skip_relocation, monterey:       "135f751b6848b20e6f3807e511c11b17ed158bd12dfca684689ee542a01183fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a45d151037f2b61395b3a99cf4235fda58f4072f9906ae8731314d625118192"
    sha256 cellar: :any_skip_relocation, catalina:       "f7f471eab180340d846c8c931837c116469215ab027c970ab3a6e0d34cab09ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fad87708073180e1aec55548332dcc3444072a72df6bd795bf9f8c7b9ac5178"
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
