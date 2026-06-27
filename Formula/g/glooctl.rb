class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.21.10.tar.gz"
  sha256 "3322df1f2dbe0bdc37d78226ccbfb2f0c6788d5433581b282f67a4f167af10e2"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubReleases` strategy.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50527c208edae802058bbb3bc24c24422aaba4f3555baa2583910a6f5b50bff3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d815bf72388777486cb0614cf335b0e4e81377130e8749a029ec8e5885ecc35a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64e83e7448935a2eac98563069589d4aebec49e680011c7b44b9cd81c28e8247"
    sha256 cellar: :any_skip_relocation, sonoma:        "8be2b832ec0966259a0bb1d2d173950a6be0c9e98b3d6b2c59c07994d14adb9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c768c84ff48076ac437eef3085bbbe87a7616dff83c1e527600656953c027c5e"
    sha256 cellar: :any,                 x86_64_linux:  "0c14afa181c9a65fd9a09a74e3dba0b8b0fb79598641a84f57e132eaf961b8b7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/solo-io/gloo/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./projects/gloo/cli/cmd"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", output

    output = shell_output("#{bin}/glooctl version -o table 2>&1")
    assert_match "Client version: #{version}", output
    assert_match "Server: version undefined", output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", output
  end
end
