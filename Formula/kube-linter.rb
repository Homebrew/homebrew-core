class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/0.2.6.tar.gz"
  sha256 "2fa6a286f2a8563b0b80186e06100f9b00c7698f528bb7ef563b0b508c2d8458"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edc3e9482784907ac7c598cf0e07c724373d37cfa264b3be14ffe6e4c0142add"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87711140134751dcea5d007d097ff4b15d607af2da66dd4612c50c1e97b20945"
    sha256 cellar: :any_skip_relocation, monterey:       "96b5b43d9be1206fff1c16c4fd2e86430e9680f09ae36eff17cad32d38b21e4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7153d6da6821e27d636c10474a5af10d15ff39d01d5acbed154829ae4b3c824"
    sha256 cellar: :any_skip_relocation, catalina:       "c7153d6da6821e27d636c10474a5af10d15ff39d01d5acbed154829ae4b3c824"
    sha256 cellar: :any_skip_relocation, mojave:         "c7153d6da6821e27d636c10474a5af10d15ff39d01d5acbed154829ae4b3c824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d1d227be6c5734af7cd11940e0429f5516e71f7574326bdc3722e0d2348bad2"
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
    EOS

    # Lint pod.yaml for default errors
    assert_match "No lint errors found!", shell_output("#{bin}/kube-linter lint pod.yaml 2>&1").chomp
    assert_equal version.to_s, shell_output("#{bin}/kube-linter version").chomp
  end
end
