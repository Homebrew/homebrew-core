class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/0.2.5.tar.gz"
  sha256 "5d2e724e291b00b6a61ebd2bd97f3f3c26298f890be2b555b60f0fb719c5384f"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a8d55efb798f0dd4897270e6ea73e3830df9966760de59648a15e9a53cc342fc"
    sha256 cellar: :any_skip_relocation, big_sur:       "1bd8e112205e4542112957730161245eb808088e2c5d0df5fa7044a63f98d879"
    sha256 cellar: :any_skip_relocation, catalina:      "1bd8e112205e4542112957730161245eb808088e2c5d0df5fa7044a63f98d879"
    sha256 cellar: :any_skip_relocation, mojave:        "1bd8e112205e4542112957730161245eb808088e2c5d0df5fa7044a63f98d879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67198dafe1a9ee7e7e6b8eeb75b18b4d2855686bea7b088eadad31320b3c0c01"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.io/kube-linter/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/kube-linter"
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
          image: busybox
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
