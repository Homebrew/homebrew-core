class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter.git",
      tag:      "0.2.0",
      revision: "a8478eef702851802631c3dfbcb1aae4126d1e61"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f8172ff5c72ebaba2fc62a26274dfe5e35765fc3f225342c26eaae6fdabcb50f"
    sha256 cellar: :any_skip_relocation, catalina: "f2430146fbe1a2dfd0ab2d2cd9e80ebed5ebf83abd2b9939c10e2945993605e1"
    sha256 cellar: :any_skip_relocation, mojave:   "8572e63e9f3c061608bbfb4a4c1ed0921b783f9d2a5ded68a812f83bff814078"
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
