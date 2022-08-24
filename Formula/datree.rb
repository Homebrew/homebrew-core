class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.12.tar.gz"
  sha256 "f5d66c2f8985b2ad47759ad0177f9251eb7c4cb3cbda50a9c41dcbf462da901b"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ee57f95942b1d8b8fecb7cc01449df6d5df6a88b8127a8c4ec45ef255915486"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10d5424aa1e1f333dab172e933e527c5868b902af1a661fac5570b7be7354afb"
    sha256 cellar: :any_skip_relocation, monterey:       "127a4a3b61d398342509d2de3bd0c45e4bffba48d9142c1b00050cd9e768c7b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "70bd9621587e3776e9c5cffbcff9dab6ef19d714b537e30e107a190c09130bb3"
    sha256 cellar: :any_skip_relocation, catalina:       "7c36e768f686343ddcc03d9227b03bded88ce1e635328320436a977f63d1bed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c631db82f5d6ccbbe0e996167a1bbeb3c66893ddb54275c72c087426cb3b0b6f"
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
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml --no-record 2>&1", 2)

    assert_match "#{version}\n", shell_output("#{bin}/datree version")
  end
end
