class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "07666f3bb620864b3ad5634d9acfff3c06964ec03c69542e21258c72a4503f40"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57e56b07eb5e7d370746159afb2ff099e2aa2cb7fd07cb0dbbad3e4c8f988bf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57e56b07eb5e7d370746159afb2ff099e2aa2cb7fd07cb0dbbad3e4c8f988bf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7653036ae62ac4e243c7e7d434b686e5a86c4188668cdaaada972b058a719af6"
    sha256 cellar: :any_skip_relocation, ventura:        "3101cc743e7cef1ea0dd23ecefe0d56ceff1e9bd7678346acb95ea82b0acdb6e"
    sha256 cellar: :any_skip_relocation, monterey:       "a05baefcd78e3deee8881422e2a22f6752230bf22f9a8df08cdba84cb58e1fcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "a05baefcd78e3deee8881422e2a22f6752230bf22f9a8df08cdba84cb58e1fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b738ca03482c4de13fb94f2c2262bdb3430f7c952aa93946b056346c563cb16"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.io/kube-linter/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/kube-linter"

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
