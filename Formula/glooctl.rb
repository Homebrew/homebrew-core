class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.8.14",
      revision: "3e2c4c69a65c853fab63aef9a936e060d7409a12"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b130805ffbb8442a1e9b9d34392bf8348ab6485c412898c5802b97e0a3d639fc"
    sha256 cellar: :any_skip_relocation, big_sur:       "6cff539c37ebf75a7653796bfab64eefe18aaff537835a7551910d8bbf7744c3"
    sha256 cellar: :any_skip_relocation, catalina:      "581ae7ead5a4529313083c3e628b7a0184545ea9c797f2f6f4bf7a47578282e2"
    sha256 cellar: :any_skip_relocation, mojave:        "0ce167d13103691192d1eb6be43f667190ef57fd54d1af7379b0fe40d14c8a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "501c218a6a2b2bb3f2fd1b98376860640f654376ee8f82809c72ea83b6dfa5ae"
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
