class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.9.9.tar.gz"
  sha256 "1de56cb9f74a549089ce610a945b103805d220a11545ba3c4d82f899ee8ca350"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f9a945b24f6c39e8fdd3819b5848bf9af67c28e2c70134aa16723e809a88d15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28d28960e79e5bdac6c42491bf3ccbb4dfadb6a0f35557f4b4d10799b6c95ded"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "338e5398b68d5c6aed1bf9ea4be3fe64d2b10893d2e2e70ce762e5a64426c74c"
    sha256 cellar: :any_skip_relocation, ventura:        "c6248bb94356831b331398db807d7777c776677db1739e1a70956fe5c31bfcd0"
    sha256 cellar: :any_skip_relocation, monterey:       "6a1b19bf41be14aa7abb1cf5dab516b4ad20cf75f322fa3c47b008c5f13a0f80"
    sha256 cellar: :any_skip_relocation, big_sur:        "a37b450e4b5d6bccecb0307279e88561496716fc60638029e77e77e633f1be2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "313ae645443f80cbb9507979f9ce8ae3b449805a991a89206940793ca39225d5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/datreeio/datree/cmd.CliVersion=#{version}"), "-tags", "main"

    generate_completions_from_executable(bin/"datree", "completion")
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
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml --no-record 2>&1", 2)

    assert_match "#{version}\n", shell_output("#{bin}/datree version")
  end
end
