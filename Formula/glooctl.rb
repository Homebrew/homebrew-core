class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.8.2",
      revision: "c357bd1fe1c47a63658d1af8f593be12b74ee38f"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d78681671207f2dd7776dfadd85294be099967f6eb267bef03872f1c533d731a"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a17592677b17b4537d4c931596388d154b54c9361a40717ef2d1486a0966fbe"
    sha256 cellar: :any_skip_relocation, catalina:      "92cafefde495fdaf6eba14e05af628faab836089b8937ca807c61ea8ad1e04c1"
    sha256 cellar: :any_skip_relocation, mojave:        "cf1f4e24d5a53a7e6e84a0762dea5771a51ae9cc0a9b73dc6203a248e779454c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2a17c246ec1989f35d62fe74ccefb727ca734889bb294e03b1a67c900e9664c"
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
