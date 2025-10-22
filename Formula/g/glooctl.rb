class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.20.3",
      revision: "f81d111a48a96517eed4e02376931505653e7d66"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb78a21264dd77491ff54db2aa87ea605404297247c417dbacab337aeb67964d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aafaa641c68b42af2d9632284ad76f9d70afb09bc214196660b31490028f4361"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "922b56e3ced0ccf1064841e44bec27cf40f6f9394102d4b6bbf0025f6611e7a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "26319eb5d56b94cb7f7aeb61d1d3080dc0d1c3d2412b76f08af6dfcae50d1831"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8252dbb5d53057d30fe99fd7f9f8bebcfc735d770ac938e687bb4e5888c54d4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30e9368d45acc0294b4064903bfd39e7465ea0e542861c416f967e23f1940d9b"
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
