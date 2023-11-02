class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.15",
      revision: "8a60defa4d62a9371ecdc2b348ae32f0a7380648"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a346784e0b2577907cc1033abdcada3ffe15b91c95413b2b6484cc31c166231"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb1c4e93026bf749c6c24c3d02e34ee403ab9d091ee4ac177cc3e03bbbfa7d7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be0f5e69f98168bb12e56d7868000289207c36c621caf4fcce2685973e3b0bba"
    sha256 cellar: :any_skip_relocation, sonoma:         "b35eb01a226de34f2c2aaa7de16739cb94f96efb8b517f8cd3ba9855a84adeb7"
    sha256 cellar: :any_skip_relocation, ventura:        "631ec15d404b61fc34344f4e0c829670349b4e43e46a406764f93558746af752"
    sha256 cellar: :any_skip_relocation, monterey:       "8fe52be5ba03f44b1c758143f9717a54f5f49ad53b2ed0efc82dfee7fd68dd71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "375b29c74e2c2be1971d71502a93554158a21e41b8658126029e8a6cabed3318"
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
