class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.12.1.tar.gz"
  sha256 "a4ccfd31ef2df7833248627e768f93f3fbb61928e7be8f2288712f189a8908c6"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "staging"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5e4f635d7a30f92153a4102da0cb8a29a4eb2eeca64435c45f9d00c5233c1a2d"
    sha256 cellar: :any_skip_relocation, big_sur:       "d1394c006bbaf48c2f7f76d3b2ec18789b882ff25212255e4f98f0c0e564e943"
    sha256 cellar: :any_skip_relocation, catalina:      "86c1d8173656ec7654456eb0b151614c9c41f4e51edd4dd7dea0f1203b39cd81"
    sha256 cellar: :any_skip_relocation, mojave:        "a237ad584c113ce24bf56eec31fbd8c4f8aafa95f00ec2140465f99fd72fdc62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d15aa7d05968331c3a8a8accf7394bcd15e7b92ee797e128eb7a5b14dc42fef"
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
