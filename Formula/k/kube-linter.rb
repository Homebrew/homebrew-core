class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "e548670732ec47e34308abc96755c2cffeeaa1d942222167669709d612caa7d1"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b16ae96700ced1179dc45c0c136a4cfeba5a5651f6e2ea38ac8886f8410b986"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b16ae96700ced1179dc45c0c136a4cfeba5a5651f6e2ea38ac8886f8410b986"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b16ae96700ced1179dc45c0c136a4cfeba5a5651f6e2ea38ac8886f8410b986"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ed1130dc09dfcebb9b263d146b4b6629b533900e4f206206c659e97ea9d79b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "470534c3ce9782cb5a59df64177e236a7b89e61951230408e80f6ab27000391e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "743b7bd5e1afb0c95f0626f45bcaecdd4c5f1f48908ece1fdff2cfd094e30421"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.io/kube-linter/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kube-linter"

    generate_completions_from_executable(bin/"kube-linter", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"pod.yaml").write <<~YAML
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
    YAML

    # Lint pod.yaml for default errors
    assert_match "No lint errors found!", shell_output("#{bin}/kube-linter lint pod.yaml 2>&1").chomp
    assert_equal version.to_s, shell_output("#{bin}/kube-linter version").chomp
  end
end
