class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.7",
      revision: "6d182c8fcffa353acde1c3e37b632486e772d753"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f42ee37bcfbd2a134d9fa43f5a6d56dba37289a6d338307e1929ebb1d9ee5853"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b90f911d72a23ea03957cf90223f27fd243bc3d5895a39e596bc3d1fd226c1b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a407c12add43c930ffb4004e585f20fac0133eb4e30e79e96e462cea96d3d1d"
    sha256 cellar: :any_skip_relocation, ventura:        "5525e7b45dd7c2fbadd6ccf45c9bdc0b09a5c8a37bbca1f5331b16511f982525"
    sha256 cellar: :any_skip_relocation, monterey:       "904515f260c7b7034fb916735d1058fee03f0f16bd238d6a87217582bea96d14"
    sha256 cellar: :any_skip_relocation, big_sur:        "f517ea72c5ab48d070ea93889c7e87fc7a9fba7b9ea8dcc1ac9973d863b26339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ce121919dc118f1160c60d30640cab15e5ff0b8fe517546cbc6fe9a01a1406a"
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
