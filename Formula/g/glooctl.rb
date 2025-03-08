class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.18.12",
      revision: "ce0e65c87bba7049622762fe2e9442e56d31f2d3"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf85ece625d2870b95b53ec3aaec4935330bb554b78ae11bc56ae439204d0d96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6fb8aa7cba3ca2f71facec21dcd3d13e312889ba849cc48a749ef15ce01b858"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d3358402f50c5ca2fa85443e059c1bc78beef46007d1e44ca3e1082cf579f63"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7b519d8dd3abf26d53d1decff571ce422cda6528230e174f3b0ee650bc310fd"
    sha256 cellar: :any_skip_relocation, ventura:       "c3a4b0faea0708819d44d46c10d90890e345e01019e0cec64837b57525790f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4db9f4526958666de8ce22d564e7c753f1892ecfd2e8896284ee20794410e7ac"
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
