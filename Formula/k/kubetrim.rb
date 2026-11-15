class Kubetrim < Formula
  desc "Trim your KUBECONFIG automatically"
  homepage "https://github.com/alexellis/kubetrim"
  url "https://github.com/alexellis/kubetrim/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "0721b0712d0184cabc3424019f161220e9ae4cc39f0eaf6cb5051ffb94d0ce80"
  license "MIT"
  head "https://github.com/alexellis/kubetrim.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60312e501a1ab9a034a7e013cd55a6e4ab95b897af49d4102a9a842245ece92d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "60312e501a1ab9a034a7e013cd55a6e4ab95b897af49d4102a9a842245ece92d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "60312e501a1ab9a034a7e013cd55a6e4ab95b897af49d4102a9a842245ece92d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3b7e561ad20d19896c56a6ad99469023acef1ef15f63f1eaa9cd0b34d15fc775"
    sha256 cellar: :any,                 x86_64_linux:      "417d96982bb20a50681ec007db57da04a6dc508f7fabc3bfac0f0d28d4f881aa"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/alexellis/kubetrim/pkg.Version=#{version} -X github.com/alexellis/kubetrim/pkg.GitCommit=#{tap.user}"
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
