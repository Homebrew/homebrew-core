class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter.git",
    tag:      "0.1.3",
    revision: "55597dc998f499fdf3ba7d0e58c501365ea66df2"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0339da5dbc9507d60a5a6089bc8a1a4662344a5a165f89f3c450e5941350e164" => :catalina
    sha256 "9b6b67038dd1db365041afd3ab9205e14d3439e2a331e696a5e0b2c4fbea73f1" => :mojave
    sha256 "020d8688cf36c0a175bbc2fa9f163b919f6482ac36b03deed8c19c1959bb39f9" => :high_sierra
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
