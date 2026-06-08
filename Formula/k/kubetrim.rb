class Kubetrim < Formula
  desc "Trim your KUBECONFIG automatically"
  homepage "https://github.com/alexellis/kubetrim"
  url "https://github.com/alexellis/kubetrim/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "24455f11699c61760613f630ded0d395cdf5b2d3925a08a730878819f353e00f"
  license "MIT"
  head "https://github.com/alexellis/kubetrim.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0e95614b8dcd84e2adfcca2d7798ba72c0aa45654e3acc19dbbb4f064164ae0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0e95614b8dcd84e2adfcca2d7798ba72c0aa45654e3acc19dbbb4f064164ae0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0e95614b8dcd84e2adfcca2d7798ba72c0aa45654e3acc19dbbb4f064164ae0"
    sha256 cellar: :any_skip_relocation, sonoma:        "33acd64292aff0e9ccb905d1442ae48275ef8ea314e8d2999340fbbb65f66553"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c156a2f72625bbd022c028f32d93bda8b61eeb91c50b43924e93ab683a264dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e68c9d12f445dfeacb5b7da067f20d7965ae7278b65717eee33d151d45cffdb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/alexellis/kubetrim/pkg.Version=#{version} -X github.com/alexellis/kubetrim/pkg.GitCommit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubetrim --help")

    # fake k8s configuration
    (testpath/".kube/config").write <<~YAML
      apiVersion: v1
      clusters:
        - cluster:
            insecure-skip-tls-verify: true
            server: 'https://localhost:6443'
          name: test-cluster
      contexts:
        - context:
            cluster: test-cluster
            user: test-user
          name: test-context
      current-context: test-context
      kind: Config
      preferences: {}
      users:
        - name: test-user
          user:
            token: test-token
    YAML

    output = shell_output("#{bin}/kubetrim -write=false")
    assert_match "failed to connect to cluster", output
  end
end
