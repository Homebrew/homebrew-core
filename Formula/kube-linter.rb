class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/0.4.0.tar.gz"
  sha256 "5397d913e757fdf80f2ebd99c1b7264a41d85d72d7d8d079a2a8dd6040c3d5c9"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb63762766d5cf3cfb301c4af41293c2b4a09168ac89d210dfeeae199ca04c75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb63762766d5cf3cfb301c4af41293c2b4a09168ac89d210dfeeae199ca04c75"
    sha256 cellar: :any_skip_relocation, monterey:       "64118cd56f20047480d0b5bd5df908f26ea0c271ad1b433febd3c3c7596aa1b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "64118cd56f20047480d0b5bd5df908f26ea0c271ad1b433febd3c3c7596aa1b3"
    sha256 cellar: :any_skip_relocation, catalina:       "64118cd56f20047480d0b5bd5df908f26ea0c271ad1b433febd3c3c7596aa1b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75ba0856c8e5ce62e2672bd8b03dbe7692db25c4d2735d53cc35e8f34f1ad22c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.io/kube-linter/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/kube-linter"

    generate_completions_from_executable(bin/"kube-linter", "completion")
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
