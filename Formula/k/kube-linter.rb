class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "4d3e5d8f006d4907e5fca03a9064d79e6267942cb2b0ae31dfbaa61e9d403568"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c509bed9270c2d7e850af0bf01a929957680c04ffd2108a370c7fc8a22b81a67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "051386ab60886bdf547bcbb69aa9c87f73e476f1fd47e653ea58f9275a4c87c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "051386ab60886bdf547bcbb69aa9c87f73e476f1fd47e653ea58f9275a4c87c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "051386ab60886bdf547bcbb69aa9c87f73e476f1fd47e653ea58f9275a4c87c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "6369533123f9bc09dc97856c029b7eb48755c606a7217858b29ca96cf3fe240f"
    sha256 cellar: :any_skip_relocation, ventura:        "6369533123f9bc09dc97856c029b7eb48755c606a7217858b29ca96cf3fe240f"
    sha256 cellar: :any_skip_relocation, monterey:       "6369533123f9bc09dc97856c029b7eb48755c606a7217858b29ca96cf3fe240f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98c79930386ea6b3c753dfd5bb33abeb75f16e6f0088efba8c1d791bd43b0337"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.io/kube-linter/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kube-linter"

    generate_completions_from_executable(bin/"kube-linter", "completion")
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
