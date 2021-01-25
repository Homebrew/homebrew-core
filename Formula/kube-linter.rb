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
    sha256 "5420d80aae62be7329f23944eddf424800abd9ffa88679628f664b672ba9d592" => :big_sur
    sha256 "93e1bcc15e05ef89f75b24be258a4e3a13dc06ac2967d0b02420d8f4ceb9d6cd" => :catalina
    sha256 "9790cd431046ab7e4464a627d8e51462313b15d59389cb7fb4e937293f2833ec" => :mojave
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
