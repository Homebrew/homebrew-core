class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.12",
      revision: "ecdf8073fbc1166eeffd1f90469b4fac14876a6c"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a810ba94d5f272bfe037f9d55b879800ad1245dfd9b47db6e0a3ae464dc28939"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d39c2bb4c00eb578734b99d5fcf3cbde781652c33f571160fb4d9af10014c03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5c551c479bd206fa86b778a8b0d6c0b77fc57a2c235f77d489b68e30fe819ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "db8fec3909995ed73ffbb9ab59c5ce32d8d128de55d9919d4a4ab3a4acd2e64e"
    sha256 cellar: :any_skip_relocation, ventura:        "064b55ed5bfb630fc15245f21030e29c86175d2906639f88dbae8f50501c2ca5"
    sha256 cellar: :any_skip_relocation, monterey:       "3086464644d786fcbb6ceed981dcdf6515bf6625272d1d730c6e18a2b497b2a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e8f20d5a1949770fdd0333611ee40200262478a3d375287fa082f657414c7bc"
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
