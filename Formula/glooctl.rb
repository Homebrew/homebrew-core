class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.8.12",
      revision: "0735b78ed07be9e897e628a6fc0feb990237231e"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "47f166d3e35492770bd88ec45b800e6904ee58f8eda912b0a16d55ef3423b0e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "b959a5d0b93483424df75edbd10d15895d59bbca64e6808c8c437a13059af377"
    sha256 cellar: :any_skip_relocation, catalina:      "2f6cb7f23f548ef7cd453db5e756f4b857d39387d4177a459d3cf5f2998a515b"
    sha256 cellar: :any_skip_relocation, mojave:        "547468685cd42d54fcaa3a9aefd580638de00af581d1520c9d6311f80fd941d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51aab7ad50649237754f0f1ca12f9e03a29c313d880fec57cb591d5dcecacfa6"
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
