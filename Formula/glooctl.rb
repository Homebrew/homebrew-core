class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.27",
      revision: "db58ad0bb4da44a0329d728259a3765d28eb47c0"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d43e661c5994d38afb7c926a5d21e4d9f8813b474e27630d0bc99544874c8a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "605266735bf2eb1f64b947537c2db71c01a955b6dc9196193962b28d13b60a52"
    sha256 cellar: :any_skip_relocation, monterey:       "2e3c33f044a85e9f36a1f6926620a0cc94e2918e74fc3ca86995f9cca66f4f2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8a1d091583648ff9f800e5397d8b68aa11c52b2e29f1b18fc2e95bd0ef0f46a"
    sha256 cellar: :any_skip_relocation, catalina:       "84dd1c1abc96213865320ff9e1a9ac9b1a77703143cfaf47d5164cad2bb2cbc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13a3e808f6625d5edcc5f2550894633196de42229127fe4153dbcc26f9861252"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=v#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"v#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
