class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.32.tar.gz"
  sha256 "14deac55bece5d7283316fec8df7234b4d28d78a890a45f26478ae3e96b950e9"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9aeeb77172e04bb3bf4e0d5a5ad37fef9d949986c1a5cec9f5d2e7df19d9efdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce97c2272131c5af537d5b2d9c5d5ea5fdb5ee385479f486a19727577bdf6e4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21ad419e60bdecbcc142ed97aaa866669a5401de5f66ea324aa5cf8d47a3cf6e"
    sha256 cellar: :any_skip_relocation, ventura:        "9b640ddf53bda40efdb9e8118080c7dfea917c7e9d388dd0d2e8249f5d244805"
    sha256 cellar: :any_skip_relocation, monterey:       "bc26dcf04b3fe7e2553acd0bb0454892ae23e8a6e4d3f4c744ad80c9550cb761"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca84082c75bfea39fde8c992939b5afd952680eb3e6185d8e62b964634c56f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d83a2ace883c5d61127c124a94974c46f0edd31a9dd0dc9ae695646bb6d520c"
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
