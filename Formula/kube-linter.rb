class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter.git",
      tag:      "0.1.6",
      revision: "a64df58c92e9dcab418e2cc9f1e796eae70b97fa"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1bedbc9c83570d1ed6b0bcaa60a9d6e310556af827af8c454f855d3843254add" => :big_sur
    sha256 "1100c06758fa31f0d252bf6e1f62db609c17fef84ed4c7438d5b2568c22fb9c1" => :catalina
    sha256 "98124d941e859486a620ba6d8358953d92735c075bbc5a65043473c9a66e259d" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install ".gobin/kube-linter"
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
  end
end
