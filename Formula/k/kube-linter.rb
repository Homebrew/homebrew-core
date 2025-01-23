class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "6b61b9dd7c458bc3509f8c4f4e68fa1e34a0419e4995b61a19a477bc0422f5df"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b15ddd54eace35740eed7fe6afb9eaf5191383c7caec0393d7337973729d3b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b15ddd54eace35740eed7fe6afb9eaf5191383c7caec0393d7337973729d3b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b15ddd54eace35740eed7fe6afb9eaf5191383c7caec0393d7337973729d3b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7a673e1cd1ca187060209047efcd97005a3bd0c230bc7b81bc24d8bb0feccff"
    sha256 cellar: :any_skip_relocation, ventura:       "e7a673e1cd1ca187060209047efcd97005a3bd0c230bc7b81bc24d8bb0feccff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aa74112dd141d09a850c5c84d92df32f3c16880db8d76193171a225f3f5a363"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.io/kube-linter/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kube-linter"

    generate_completions_from_executable(bin/"kube-linter", "completion")
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
