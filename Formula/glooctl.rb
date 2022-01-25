class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.3",
      revision: "a6045572ff84d8c2fea9c1d456a3d5731181ac9c"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "371cdc894033b26504afb59a382e63bcd84f93bd21b49661a48ee13fe559a698"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b789c1aa016bdb958a2cc5fa9adf8e5866f8a886d6d2caa0d8e42f38a3cf05d6"
    sha256 cellar: :any_skip_relocation, monterey:       "de5fcf774732b9fe1e775c48fe20ce42bd743dbeed1f0ffc6cabc6aab05446ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "1073bebf9342a03c197ca3d9c0cae32d6f54808180c1153b4e9a69f2dae29dfa"
    sha256 cellar: :any_skip_relocation, catalina:       "7c90bf29ed91d539938b3d12edfaf65ba72aa6f5d0a885a0f332fddf246aa501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58649c5868e7e051b7cb659fd23990a92f2001e2edfb178ba2dfa49b0e0daa64"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "TAGGED_VERSION=v#{version}"
    bin.install "_output/glooctl"
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
