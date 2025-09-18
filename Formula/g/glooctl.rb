class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.19.6",
      revision: "7b1bfd8189cd4797fc55ebb0b6b3422dbb741333"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d15a5f6d0d89dfc886352bf41ea25b2cbe83c33f07265d0537927302abcaa39d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a2e2685f46039b058a4c8cf876d9c85f0c67c4fe5a4c079c8aefa7149aecd08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87e8715795a8167ebddde490a44863479edd822889641482d35a4eaec4442c50"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08283b15f22c600bc1676e625c9549b6ee14af3133719f0e341546d94d575ff5"
    sha256 cellar: :any_skip_relocation, sonoma:        "42a01d4aa53d29f81bf2edd475a53efa1b6b0b76370e8cf508ccc260d8c44fb4"
    sha256 cellar: :any_skip_relocation, ventura:       "2448a4a0cfc9f0e603fc8f5b6b71c05fe8644aad17133a818fab9e219b2f3b6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0251a4d8375cb87f8d027903535e43d5cc6a7047bbff68315c03979f97460f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "361e674c2caf609643145772947d23402e5c8752e31603b9343ec26ac0e03437"
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
