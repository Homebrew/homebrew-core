class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.13.12",
      revision: "d6e0c1c73236ac33656824accbf22bece8d78c0c"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8f88065a176b410997206dd18d0591a2c437046a05dfe90a0449152fddf8989"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69861c2448352f60a68837b6ca4f061c6d4daba9610727c458fd8bd5781f79e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "235ff3b64325fc1ff93772dd2b77c0f018d56b423cb0648494caeddac5d69a90"
    sha256 cellar: :any_skip_relocation, ventura:        "e3dd6ad42a74248fb4dd1af03cf381bb2aaf64f1144b95867b2c8c0838a70047"
    sha256 cellar: :any_skip_relocation, monterey:       "a8af501c54d2d65b28809b99e5cde388bc4d733379086e7a79967f78eaec30b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "41bbe0fe1bd0f14b9308f3f0d38d19a1592b6e20f72c41404dc2f15da83cf181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24e4d072e23b28ed9952aac8cf6c81dabadb73ca3aa8ac29ecdf900872bf5bfa"
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
