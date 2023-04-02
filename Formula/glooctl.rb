class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.13.9",
      revision: "43cefbf5d76037c11d6e7ced20b541bd31369d97"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9528c16a9e71640370f24f61ebfce905989c9b5dac2498ba4d9c6c1f9723aea6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dabf015143320f50962e6cc838fdd5bb1017d68662b4a4f543039f41d832011b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "378ed5eed52d33dd990d5b77606270bdc074389c1538648aafda14d45554b89d"
    sha256 cellar: :any_skip_relocation, ventura:        "a60cf1b0287c623eb2c0a8fe25e79497dc9aaf46c19c93efe617fc1565938b7f"
    sha256 cellar: :any_skip_relocation, monterey:       "6c5c99d2dd4438994db70f0058b9aa9898e151054c6deaffed393dde0a6a0724"
    sha256 cellar: :any_skip_relocation, big_sur:        "8724e3e145e5a342f712641362a059cdef1e968c11611e98b4a7d14e21b33f9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b078025823fade18a563393e0e1a3112fa56ac464a459db586d9e86ec2b0ec01"
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
