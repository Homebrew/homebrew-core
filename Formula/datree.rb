class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.15.52.tar.gz"
  sha256 "00f99cf86ef12333e168c685d405d3667c636761c4d9ca3752af3740e5e61831"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb5caf604233fe01bac5c1df9a69fdfe3ef121921200ec1ca79bfbe5a22fb916"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4f15bb353456585d5132b3d01b6c75723e3d3f9c34d2cc525b39c222dd1cc44"
    sha256 cellar: :any_skip_relocation, monterey:       "37b2db077f0972f0d5041b9f8fed0e5c466718bf6e6b160af63ed5067e01d627"
    sha256 cellar: :any_skip_relocation, big_sur:        "20ca32c2abaf5313646de119ea999ba94e1d3876df0bce9f1aef2781510e1f16"
    sha256 cellar: :any_skip_relocation, catalina:       "c78cd31843aba7c4abcec997a6489a5c41d71ba58d7d105bef84e3b139882fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff22f1f67ca49169b5962a3779a027941d359e4f4abbe30882d6e35acf7708f3"
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
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml 2>&1", 2)

    assert_equal "#{version}\n", shell_output("#{bin}/datree version")
  end
end
