class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.5.17.tar.gz"
  sha256 "3085e04d8a9ce90a0606c6379a78c436ce778198c746cc9a66f1992ab036ba37"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "961ca57b1a794ab032938e3ec9ca0b1227ea02c058e5a66e92f14b5ec14ba1da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8919926b656587cee499a9baab676b8defc02b7c719e526736fbd7ec4bc34c6"
    sha256 cellar: :any_skip_relocation, monterey:       "085d9636ea47525cb03e31f45acd6134e9f2884d914255b23c01fe9e009e9ebb"
    sha256 cellar: :any_skip_relocation, big_sur:        "aede83341b134900c5087859193ecd6caf520f89083666c88052ade50299f42b"
    sha256 cellar: :any_skip_relocation, catalina:       "1813ad5454838012faf4b3085f9216b624f5e6634941460017c19338eb738fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ad349ef4f4ac1b989362d4cbddb3aed986382acf3da26754871bd96c7923f64"
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
