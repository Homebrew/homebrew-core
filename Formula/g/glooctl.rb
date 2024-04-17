class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.16.10",
      revision: "faf5230b6176ebea73286e609171cc728cd15d37"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6ef8e5a97b474fe4d45aaf7ac00a5993ce5303b168c2e88cdd2220dfb0dc602"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1644086babf30463a57bb0b6a541c90a811eb894826332366f0b980e6582b90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ae5454da813aa63549967b0cc9028f99d81f1e65c469472fed51a126fa79b82"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ac3630b5236b99552cc552229decfd19cf792f88d7f7b061318adfc41e9a650"
    sha256 cellar: :any_skip_relocation, ventura:        "75b46298e75f00487b71abf14155f6b6b9e8b51e5602ae6f2a2efb20f96ff822"
    sha256 cellar: :any_skip_relocation, monterey:       "434cacc4ae809dc71718d852404bc66956a736b1d71789104e5ddc464099a39e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b99f7957d43d31e7851078b843ef6ec74e603c2f96ec77a4ba3d80128a19829"
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
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
