class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.18.16",
      revision: "022d5bbd26ff673d7666a676dbf7873b2885bb30"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a901befbb8dbb8e3caf7f1dfbeda319d2d552ce39b2d85e43a55de02f3d23e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96fb9eb10bf40060265060cc9cec68c0c48fc9a829a46adb0d895c5d97b78c54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98a6bdcb3deec8a5af3ee83cff71bb4bb2479bc984519986bc86181f840c4d49"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb48083f654a9b74e69855a205e37f878d0d3d2456d6b55922f6ccc450d2c861"
    sha256 cellar: :any_skip_relocation, ventura:       "5dae6872ea30e548017be6d06f3a482a0902d5f4d9097e06a1a74bb2621395ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd118b80f5a7e27bd3386372fe3422f0b2c4cf36df8c913704224c99937d9b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4484d3f1060b573e0a8f92adc1b4b4c7f1fae61a0b37ac86869aeb98a65e5ebb"
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
