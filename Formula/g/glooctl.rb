class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.16.13",
      revision: "d4724c01b605e86ac845f6ba0830d6d4b0554e15"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd93e51616fce457a486d1226a3ea02df2e69b7093612c8c0498cbe58831b212"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "894b40e548635e8caaeef2a8559fbe761bafc5e8457bada92c7a9fa8a27439a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "013d110b61382c0354889922ca26cdf4ddd8f67b494ac381d90667fb8e926555"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0f671463aae1478c4dda2c025929292e5baedbfb8be60d35fdfa0b88ddc1de2"
    sha256 cellar: :any_skip_relocation, ventura:        "ce7d85058ab33de98abe56b6fa6474cf0b00723ce45475b92a108bf74c1b6523"
    sha256 cellar: :any_skip_relocation, monterey:       "2247236f36cc50939033b98e1a3f6ce5af9224b336e95fabe5bbb85f338b479f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "356e5076be5584ee37d98d0af4a49290d7a1be35f8ea83922a6088e2a0244c6b"
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
