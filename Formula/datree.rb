class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.15.16.tar.gz"
  sha256 "025934c204667f4dcd1e130e62e5e32cb710577173f4a4801fca7c279170efe1"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bb0580167bde3aaaaab0e9d7fbf91dd05a1273048370672bfcc6437bbd68b62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17cf15da8dac64c39b981fc39cf11f1b100a704754d4d39204670bb2667efbaa"
    sha256 cellar: :any_skip_relocation, monterey:       "2896b3ace34e4bca538970aad3c90dd4e76adeb8c0f14c3d86a07e01686b2a59"
    sha256 cellar: :any_skip_relocation, big_sur:        "f605b18a3f86f58f4f41514245c27e710c37f08c088c1b91f3c330fa87fb1793"
    sha256 cellar: :any_skip_relocation, catalina:       "76ad5357ba3c1c8beaeaa0e0ddfb3ae294e9c01e229246c300115ad63b920b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9edfae6024b56e801cac928de54dc4cc07c4052a6622ef1f20e40a407655a7b1"
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
