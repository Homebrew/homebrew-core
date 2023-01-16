class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.14.tar.gz"
  sha256 "e2b21bff5faef90975dfe3efd28cba00c8ac46f8901b5183d4bbbf66568baf7d"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57736038d7b0521d16e5beb7cfb7623b0ccaa46bcc285a61d9b2bd23062b5d72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2488cc350303f3e5f7a7564f53d665d3c6a6343964512129054f87c9f6c74f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cd334424707777449681dd3fef05cd8d4b8e0dc731a7cd79daf6b587bc05956"
    sha256 cellar: :any_skip_relocation, ventura:        "ec072ed1c820a17499e7bea04ae4729f88d0d9cfecad04adbe2b85ebe612c703"
    sha256 cellar: :any_skip_relocation, monterey:       "79e443265324332374329135fe1158b18f7354c1a23899dd28b8eb1116c730d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac9fe894a8a91ab22cd375133fe728522ce5e49689ff4cfbae94bfc2759a8b60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95b00e86c83ee64372c5384ab90547089db3b748cfe392eafaabaed0e348746c"
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
