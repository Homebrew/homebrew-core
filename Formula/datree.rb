class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.14.85.tar.gz"
  sha256 "77c6670c6c623c1eb01e8a7a6965563f6dc8ef213d9431566107899039549326"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86c1871f9dc02bdde3198619c74a561af19230dd13427b7b662ff97ece969ad4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4764e387c742aadc5cc55791a5b2d70ee3ce6cbc086fa68de13d76b433ba75c"
    sha256 cellar: :any_skip_relocation, monterey:       "3e9f7d798ee41032882da68b2fe885da2663b6ce96a63ee815c81956cc22de7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8e8e3bb410106d784a4e1d5e76377ef99673a06a87e3ed3ad278ff0e13ac4eb"
    sha256 cellar: :any_skip_relocation, catalina:       "3c07078acb3b3b4714d8976f651a1243ffda1afd0aef8294fccbb98aef8916fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87814ca54e675df7a8a224393529c4c8d93b61a85432c9fb3b367f10429e6cb1"
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
