class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.4.17.tar.gz"
  sha256 "b4b99ae99dfc9a77a4add4eb88af25e9c91193629a10ea91ac8f9e8c2b8563c4"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "781d7fb1a8d55dc0b5e173aaa42378c03dfb2e65705df8541b753407b751cf0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f69564367371b87edc37657912c9c2f81fb9d785185a3988059ec22480e18ec"
    sha256 cellar: :any_skip_relocation, monterey:       "35c334781f807d05072ea64b9d4d272d712b4222147585f6a939213f5ab1c961"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ba3ab5848c36a4ff519ced84bf687a04499efbc26c19328e72203b4b4cf7ed8"
    sha256 cellar: :any_skip_relocation, catalina:       "f9cf9a30b85d683eb4a80a28b300008c290c35e72687cacc3291ceccc11ffa87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c03b722676563951a61e30d3d8e2530c28215fc14b9459daf1983a2ce0bb670f"
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
