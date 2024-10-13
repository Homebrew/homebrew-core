class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.17.14",
      revision: "22eddad55f6ca6bc6958df6cb095afc6ef730984"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "000bdb700def5ad9bc81a4103ab9c41aceb45bb4831c6e8da39a221e33916e4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5ba9957518937ed5346fcf26d210a48ad0bf2d1f932ab2bee2efa69ece9c554"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "579616451645a88e614954ccc898b018f321b53173ce5232175d80712f3e5b36"
    sha256 cellar: :any_skip_relocation, sonoma:        "395c5098d7daaf4f5749007c26f2986f057976b9d154f66934ba7d84eb941afe"
    sha256 cellar: :any_skip_relocation, ventura:       "d29094f6551d67040f4457fe84cd6c38a93daf9f7838cda1e314c3452a1d86a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb39e3352c68c0f5e969f60aaaba56825ad9d552d12ea26b09540d4c7954b2f8"
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
