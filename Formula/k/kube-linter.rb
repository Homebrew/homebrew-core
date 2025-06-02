class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "e6718eef1f964cd9ef82144deb79db4c4bf0907115613f77091951cbabd4e8bb"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87b59ecf25a7798396243cea61f112484c033d51b3a0f6f114504caa0de38f8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87b59ecf25a7798396243cea61f112484c033d51b3a0f6f114504caa0de38f8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87b59ecf25a7798396243cea61f112484c033d51b3a0f6f114504caa0de38f8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4188d431207630a63971c36d03d615f5e223bf22278aaa607c8b706c4454c818"
    sha256 cellar: :any_skip_relocation, ventura:       "4188d431207630a63971c36d03d615f5e223bf22278aaa607c8b706c4454c818"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9af5b3f787bfc216c4a89f846d4c3cea9dba854e1032895e090113d7a1f9c7ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9664b67c1bbdf51da6e5fc9c5d3350211f3893a86586e8cfee6a5260933e6565"
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
