class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "d83bb858531afce887416f6f0da0132a38b06c28b5da4b989363061a9ad65ca8"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b7cca3d812f443f35bcafe33c357278fe3939a7a0d00a40e26d01c33a9e8299"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b7cca3d812f443f35bcafe33c357278fe3939a7a0d00a40e26d01c33a9e8299"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b7cca3d812f443f35bcafe33c357278fe3939a7a0d00a40e26d01c33a9e8299"
    sha256 cellar: :any_skip_relocation, ventura:        "299bafe97d40e0b196dc2517a800bb1f9283473678a224d3767e34ded7a0b92a"
    sha256 cellar: :any_skip_relocation, monterey:       "299bafe97d40e0b196dc2517a800bb1f9283473678a224d3767e34ded7a0b92a"
    sha256 cellar: :any_skip_relocation, big_sur:        "299bafe97d40e0b196dc2517a800bb1f9283473678a224d3767e34ded7a0b92a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1827dd57e21a00ee87db0c24a5505d8371f30326eea54c2d5e99f0cf7f882509"
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
