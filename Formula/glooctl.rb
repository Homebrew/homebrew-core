class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.3",
      revision: "c9b1faa40ec0b89253b39f5998b32de8b45851e4"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0222e4fb196d99ef95f9e13384f40a3c72787d3ccb69f0d193d4c94f6d29cbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2805e2e929e2805855f02d901e0dccd9ce691db7e660fb36ce687380b24294db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a22395ac133fdaf723fb0ef11f66670f93990f0f568fa952d61b44a5f40deb7d"
    sha256 cellar: :any_skip_relocation, ventura:        "fe256b47023b6446e2fd0af29620ba65dae809bf3e783816fddc67570177a17e"
    sha256 cellar: :any_skip_relocation, monterey:       "27502e16ab41f7d42c310b5b17957301707d9e005b45974342c6b3342001bd41"
    sha256 cellar: :any_skip_relocation, big_sur:        "67078372f3d577d24e6c77e01023988705e2f48db9c2134df284171ea5ae8cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "715c43565ee2defdd5737da17338c37c6aab4f4e8a47baf79f2fcc1eaf2983d2"
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
