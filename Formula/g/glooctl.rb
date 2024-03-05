class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.16.6",
      revision: "c746b6832a502ad0e9f00786085b9492b43dbc2c"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0898a6e2b9acdbbfb93f14ee244b71d8a5a6f357dd37d67aad60031d168b1f39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3568eb45fe7c7e290a108fb6a90df1d0c8022c17826f0455d0a581c913f005d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae40fabb4a9b8f459c1f1c04e1443bd7ba65f06d042d92e523c7ef18c452ff22"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8b5136e6484222e0a5b2afe79ae560ada7e85d309b91900b7079a98d8000d0c"
    sha256 cellar: :any_skip_relocation, ventura:        "7c0022df4a4fb0901bac280c2fc3555a48d25bdd430e8226039c0b95fc0c554d"
    sha256 cellar: :any_skip_relocation, monterey:       "7de8be26419015970e6278d16673bfb16a382e6c2d4f3f073bb34ceaebaf3891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72fac18e97b109a1efcad56c1167700d3400ec06ae5bc03f893d1de9a5596e40"
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
