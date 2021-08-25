class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.7.1.tar.gz"
  sha256 "5a17495e60e7748d236af16a56485138d2e10bd769b7779033d0eb37e6f90fb7"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "staging"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "03cd690be4f19f8995b8db44af2c65667fc047687dc0a72db80bfb95b452ffc3"
    sha256 cellar: :any_skip_relocation, big_sur:       "4556847bcbc60fdacc323a8c832a02eeba10b0ab01497adde6bdd15df273fdbe"
    sha256 cellar: :any_skip_relocation, catalina:      "6d59313778325f28d6858f7e36b578ba8d27c19f2809e9df6f1b2e709010c879"
    sha256 cellar: :any_skip_relocation, mojave:        "1c00134b785c2204486e3d926f70d959f891e131bbc366ab527d2ee581928618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9cfb7e62cb37f850c1d607fe91a55dbfc95a615742efeb2909fd827297ff5b1"
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

    assert_match "k8s schema validation error: error while parsing: missing 'apiVersion' key",
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml 2>&1", 1)

    assert_equal "#{version}\n", shell_output("#{bin}/datree version")
  end
end
