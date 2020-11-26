class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter.git",
    tag:      "0.1.4",
    revision: "12db88411cafedbe9d6870d57a45c0927d27a760"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c4598a3d75b5b92d26afce327efd1deace98b6a5ce9e3ed8950b9f4c9290828" => :big_sur
    sha256 "a70d385c7815fc90b18c2ea7a7bb3229abe33b98a4c0f253c798c5a84ce59dd6" => :catalina
    sha256 "11ca1e5548093c88e1a98db5edd2884f9cc152208369c695e8cf44107b21e5fd" => :mojave
    sha256 "cc48078561d01be76c29fdd051bda565820026e48721117c88879fba624d092b" => :high_sierra
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
