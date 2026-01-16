class Kubetrim < Formula
  desc "Trim your KUBECONFIG automatically"
  homepage "https://github.com/alexellis/kubetrim"
  url "https://github.com/alexellis/kubetrim/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "fb1c127efa8c927e74627bae9a043e2cf505183d607cbfacf6eea8c8449a3383"
  license "MIT"
  head "https://github.com/alexellis/kubetrim.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6deadec532cc2aa53922e706aed6f60d1ae72a75b34db8a8a658026f4178d7f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acbcdd0bef57b7bebf823e4a8188e92008bd28ff5bddad717c6d730e4931a30e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acbcdd0bef57b7bebf823e4a8188e92008bd28ff5bddad717c6d730e4931a30e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acbcdd0bef57b7bebf823e4a8188e92008bd28ff5bddad717c6d730e4931a30e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c713518860291419d0aeaad5f01749956988e7ad1f633f99f5fc016048cd8bd5"
    sha256 cellar: :any_skip_relocation, ventura:       "c713518860291419d0aeaad5f01749956988e7ad1f633f99f5fc016048cd8bd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28e5239111d8a8f3731fed5f0a05a8f0499563e272e2e166d3a7f4362f421feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6e37b854d49f12f623eaa6ab5f2415d096b9fe0c6e319e7b62212d34e627332"
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
