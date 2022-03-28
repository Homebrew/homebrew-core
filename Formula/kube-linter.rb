class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/0.2.6.tar.gz"
  sha256 "2fa6a286f2a8563b0b80186e06100f9b00c7698f528bb7ef563b0b508c2d8458"
  license "Apache-2.0"
  revision 1
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c859f9440e3f4a695606b23f0d334b65b39f20d52b2422b6bc319d59f1fefe2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c859f9440e3f4a695606b23f0d334b65b39f20d52b2422b6bc319d59f1fefe2"
    sha256 cellar: :any_skip_relocation, monterey:       "f474d229424aeb5dafc9070f31c5990b41cca5c139acfc0e305a65d138935079"
    sha256 cellar: :any_skip_relocation, big_sur:        "f474d229424aeb5dafc9070f31c5990b41cca5c139acfc0e305a65d138935079"
    sha256 cellar: :any_skip_relocation, catalina:       "f474d229424aeb5dafc9070f31c5990b41cca5c139acfc0e305a65d138935079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c13aac991108ce72cf79281ca914e6684bd3f8300cba56c3f1533339a50aed4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.io/kube-linter/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/kube-linter"

    bash_output = Utils.safe_popen_read(bin/"kube-linter", "completion", "bash")
    (bash_completion/"kube-linter").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"kube-linter", "completion", "zsh")
    (zsh_completion/"_kube-linter").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"kube-linter", "completion", "fish")
    (fish_completion/"kube-linter.fish").write fish_output
  end

  test do
    (testpath/"pod.yaml").write <<~EOS
      apiVersion: v1
      kind: Pod
      metadata:
        name: homebrew-demo
      spec:
        securityContext:
          runAsUser: 1000
          runAsGroup: 3000
          fsGroup: 2000
        containers:
        - name: homebrew-test
          image: busybox:stable
          resources:
            limits:
              memory: "128Mi"
              cpu: "500m"
            requests:
              memory: "64Mi"
              cpu: "250m"
          securityContext:
            readOnlyRootFilesystem: true
    EOS

    # Lint pod.yaml for default errors
    assert_match "No lint errors found!", shell_output("#{bin}/kube-linter lint pod.yaml 2>&1").chomp
    assert_equal version.to_s, shell_output("#{bin}/kube-linter version").chomp
  end
end
