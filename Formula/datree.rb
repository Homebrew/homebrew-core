class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.14.4.tar.gz"
  sha256 "d05dbf1a6caafefc5f5efea411e52baa303ca11ac38f922c1342f6d5c9be401b"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "91ddc1e5d82262863d2dc475a96eccac55db3671492c3e72f27a8272fac0d6f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "c38ff93b54b723edf98ef6b00030a37b4936d54f114ae4d5580e18d2a4ab46fd"
    sha256 cellar: :any_skip_relocation, catalina:      "48d672fbbf2ad5731d4e02e9a33a8354db3f6cea5f5ffdfed869350985399e86"
    sha256 cellar: :any_skip_relocation, mojave:        "5f57cb8780b8d63ac7861fe1519b5bd7b6c957bb88fa479f74bb33de84e0b293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90f47ee69fe6a2ac92db1a5f831f10fb4141cdad6d16f8b5bc3529de395df5de"
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
