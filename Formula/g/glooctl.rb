class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.18.6",
      revision: "98f32bc97a3b515e73c48a4c1fd5aaaa9f901ad4"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eec958a234f58e7a7c83270642b5b6f274a82eb98d0071f7149b3c2a2dd3d798"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f43a67c574612ee9fb15a40b17ae638f194a830ba1b674d655eada993f1b7986"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "770cdab3948b20a89a4166c052521c64c9538afd305f0193577d41b4fa58df6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "169cd54f9059e54c4a505344daf19cddcf6885c7173f77649db71ebce8a17bfe"
    sha256 cellar: :any_skip_relocation, ventura:       "7a53947a6085c932f0191eaf47d2534655fb53f0f964307cf1056bb9272981cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd6dbf9a734ee95745649d1bd031027f98fe750e9c588784e6d81fdcbe88d8bd"
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
