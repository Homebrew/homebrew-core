class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.37.tar.gz"
  sha256 "a15c57cd987aa8ae75a48cc1926b6614cc959dbba9fc2ad297afa8717bb228fc"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e68dc4ab034636963c67cf4164e5bf6f713a06a2339331973146cd595636c2c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46a6f0a94c24dcb847f32fb6da86e2786063c81deeef45af9e85296e38cda8d5"
    sha256 cellar: :any_skip_relocation, monterey:       "fe02a169abfec681a0f1c20c834d03011847d4d912bb4043175861548a2034cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa28423ec1624ed1f102c58c1be26fbeb7b19c97daaad483071af2a6a146f46b"
    sha256 cellar: :any_skip_relocation, catalina:       "32e540194e2dedeeb020224f3524cd1b47538a908ff4de99aa77ca996092fd25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1cfa7a82ccbe83c113c51ff248a60c86ad341cd562bbcec3040f7c138d9fe71"
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
