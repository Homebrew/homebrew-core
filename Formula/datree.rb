class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.12.1.tar.gz"
  sha256 "a4ccfd31ef2df7833248627e768f93f3fbb61928e7be8f2288712f189a8908c6"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "staging"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3dfeacb6d4db33ee1e7dc6e578c8f79fe05dab6a096cd09b6c1bddb860a8629"
    sha256 cellar: :any_skip_relocation, big_sur:       "b33f71addc4f2b5897ac1d354ec02ed22152386b1bba8430b1c418d65bb922ed"
    sha256 cellar: :any_skip_relocation, catalina:      "97f14aafe5fb6f6a6812572b22ad45214662dc9cd914ef883191cdba15e4ce8a"
    sha256 cellar: :any_skip_relocation, mojave:        "fad3fc1f81349d70436f95e8e3b81c07e6b22fb01f526400b211d337ba522532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8a707f4af82fdff4ed3583a125071f01ece704828c5de5f961f0b6ec73daffc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/datreeio/datree/cmd.CliVersion=#{version}"), "-tags", "main"
  end

  test do
    (testpath/"invalidK8sSchema.yaml").write <<~EOS
      apiversion: v1
      kind: Service
      metadata:
        name: my-service
      spec:
        selector:
          app: MyApp
        ports:
          - protocol: TCP
            port: 80
            targetPort: 9376
    EOS

    assert_match "k8s schema validation error: For field (root): Additional property apiversion is not allowed",
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml 2>&1", 1)

    assert_equal "#{version}\n", shell_output("#{bin}/datree version")
  end
end
