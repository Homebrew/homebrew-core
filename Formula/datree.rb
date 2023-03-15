class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.42.tar.gz"
  sha256 "b3a134fa725209f005587b97d5ecb5d0767f55f24d455cebde6420aa31dd6db1"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4febd2b33dea1f0871fb794d7272055def108c60ffd0114285c29d0d56991da0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1296fcf5ab80f8c51d8b6a349a4bcd8b613c60b9b91ccf51b5569bcfe3d0ffd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc332281c6377db0db64ca216a75af656b73a8094c06cb6e131ee4db348cd939"
    sha256 cellar: :any_skip_relocation, ventura:        "f2a438e89f901b3f35ded432c8127851faca921f86890db7ac9bb6f51c22cbf0"
    sha256 cellar: :any_skip_relocation, monterey:       "794113d547cfce46993d17e21650971db5d3dfe83ee6fab59b5297808c021ecd"
    sha256 cellar: :any_skip_relocation, big_sur:        "deeaea68f26fa7e9a10864634ad815559cecc49d9560f9fb21be76ae6a613b34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f6ca9a19fbc51f76d97982271c6a3616c3da4c3d142653b26b9b96cf089c75f"
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
