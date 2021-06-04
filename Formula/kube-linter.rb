class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter.git",
      tag:      "0.2.2",
      revision: "2d8dff014dda8cd6a7ea10bf665ec421c9350b5c"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "831b22931fea72de98b288d96f2ff9c13ad078a88ab2600748434dbd7b8dfd65"
    sha256 cellar: :any_skip_relocation, catalina: "3d1f9812399cfa72f61cb2c6b3177a739a246e6408ccf47a4455864ef1685cf8"
    sha256 cellar: :any_skip_relocation, mojave:   "ae7e49df2df920ae83c66326429d06c4f748c0d3f6ee61f5d3d70e9006d6051f"
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
