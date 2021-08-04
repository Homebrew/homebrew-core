class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.8.5",
      revision: "f1b134aea13345e03f553e6141abdb7d722d2e3d"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "518f77077f2bca190118aa24f4d718f1bb530e902a6c72a9b2d5878e6d663e59"
    sha256 cellar: :any_skip_relocation, big_sur:       "93230d22867c8ecfe580bb82fe5d3cfd938d61925c66bb94b179ce9fef7cd320"
    sha256 cellar: :any_skip_relocation, catalina:      "bd1d406c9af01d6f0ebe8f2c7e4db656c97bb2e4bff77ea861b46033ed528b25"
    sha256 cellar: :any_skip_relocation, mojave:        "2953301c57fbd8577a5b24366152c4b1ef2b217db62e0ba1830adf479bcff192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41b0b4e5b63827a85ad9a2aaf06f8c6ffda5a8380ae243b3a6878ddfd7f1911c"
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
