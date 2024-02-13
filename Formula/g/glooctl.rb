class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.16.4",
      revision: "fb412e06e38aaf85ae206f06e180e08a7ad56b00"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a60259caf87cdfe927a5f46e51751baea171bf8752d49214b5af53dd0bf755ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c985cf9ad928ea086deedc7141a525f509bb1b616be8aa44f295ee1d3a20877"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbf8e0b5297f2a10769ef00a7382dd751a04178d41266c005e5d8649bdf87cbc"
    sha256 cellar: :any_skip_relocation, sonoma:         "b79f67d37ddab6f3c1ee885e57130a92e7b4f34b0d0ad9bb4f16f780fa9cb7f5"
    sha256 cellar: :any_skip_relocation, ventura:        "cea61f6f4e8531d502799c3f6dbd25dbab1e1298017a659af848712dea3d157d"
    sha256 cellar: :any_skip_relocation, monterey:       "545f23e43c81853c1914fc82e77b9b6589d9c477fc0ef86e6de90b6352db5fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c3a7a00ab34dd1108c850c5c2338bafd9de48af0f35b92d12b1b15df607a4b5"
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
