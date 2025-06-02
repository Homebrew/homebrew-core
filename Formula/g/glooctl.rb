class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.19.0",
      revision: "6be064a379000f6ede4780a4d93df0840bc1df5d"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61a6cf4d8d4d76c5d7cdd91ccca80ac089c64f31362d23d8adfeab11699539af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "106904843931a8172ab8cecb9ae0f5393c535d5a276674b54336e7cab7fb5924"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b46473f2df67b970c7a739c7b56788b269a671f4f0e561533b0b933c3bf51cc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c547ae56c044b4b3c1751cc835724bb818be338434541af74a39df97ad53dfa"
    sha256 cellar: :any_skip_relocation, ventura:       "72a1708278ef092b8b3a6f46821f731f77a163ef34d71d3bfc187baf7257c14b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b85233217e8f90b5b7b9d7505553b662040dac0e060e6c0fd6bdc9108813cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e97a6950a2489d7f888ac8bd1347babe3fc51ed7235e9ae53d344e9b8c87c59"
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
    assert_match "\"client\": {\n    \"version\": \"#{version}\"\n  }\n}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
