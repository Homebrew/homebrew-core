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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f50d66ff681f9af9d5afd7bb25a9104ecb2ace2967c1ed4d1a5c7b658e03017"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2267c69b75272529987867da85e511aa4e559ca19217caa29ba0af042b637ece"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df278177d54faac7c38d5511e85cc559e6d7918ff0021993fe13a7e0b49e4325"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdedd1b21ddbf3e919b2ef416e602aae8c3e248b35485bb27a9212fc1c9c7bd0"
    sha256 cellar: :any_skip_relocation, ventura:        "ea805768983270f12e8bcf97baa2559cd85ccfedb21e85ee289e196086e2a81b"
    sha256 cellar: :any_skip_relocation, monterey:       "13a357f44f29317f6f580635a83b20cf3770517bfb9ccf5990897c7d28eca35f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc1825b4b89fcefbe9d8a7a18a2be5583d728b427968e8ba9b0d84803aca2f1f"
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
