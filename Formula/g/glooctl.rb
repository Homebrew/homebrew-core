class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.18.5",
      revision: "4d967c194137fb2a013b8fb1d5a267698015b5f6"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c3604ea70e39e9f2b7483c958686c79be65084f1d82127275e5eb2512da5b80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b09204b78122220a91a52ae05ec2e2124b9d6a19ff712a488864bd1d56eb281a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd18fd2239e8e390a0d451749fa56d60a8412ed4fd78fdc1384d5f4f0e6fe301"
    sha256 cellar: :any_skip_relocation, sonoma:        "3002fc037b89f577b00f19fee5dccc252b2711ebd99df8390aaa990c990cde46"
    sha256 cellar: :any_skip_relocation, ventura:       "22f57cbe6550ec0ae39abac5b54c38a005ea9e2c655022860cbe48036bc5f124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe3a10d109ba0e6eb8c60063f3b35aa8fcab5e87649aa72707881bbb057af501"
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
