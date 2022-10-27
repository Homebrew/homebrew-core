class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.33",
      revision: "e1259de78e866fda234012d5a3734edef3cf0609"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7567b09a10e4098ad83a6ecf471de1e0c3650d4adfbf3a5ce002b314c7aed85e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c32029358548c0aade5620b6942c6702a6ca81416ce018c61e0e86b40498e89b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9451b881aab5a12951c3fad502e3c2baf88c8a9d6876e0c434e199da182eaf9"
    sha256 cellar: :any_skip_relocation, monterey:       "1e6421be4993522a39ad3d067a30b30713f9719f7a926ebe3d1b4d7d18f36337"
    sha256 cellar: :any_skip_relocation, big_sur:        "796f1355eeb1f2194b5b112a46689f2de44a97f80111ccc15f93dabf2757bf79"
    sha256 cellar: :any_skip_relocation, catalina:       "6ff16d4e8727558ec0aa3cf18e39dcd8d513975cad29e15111dd6eea8e8172f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "838b17a89cddce06538ee36afdf757e652074273233a908bc0fe02ecf57e3513"
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
