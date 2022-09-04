class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.14.tar.gz"
  sha256 "ff0a78ba1d3c1f3403ab88ddc0f2baf5b05f0a83bacfc616be263b1185c12465"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "466c1e8ea83112c368bb1d3be278ecad46ba136e53eae1162541aa731600c181"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2455f397d17c8aab657cfd0616d4a2e7e0284ca56556964745cc3e00c7fb0a9a"
    sha256 cellar: :any_skip_relocation, monterey:       "abfdad64e7009a8021dd4e7f559e26065b79dead3f86c96f4e85e417c8ad98e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6c3b18ed1ae39b6e6e87ae8bbe0651497969b87ec062e6a1517b09519e23034"
    sha256 cellar: :any_skip_relocation, catalina:       "4df3ac649c8e038fb57ff5b0d60c179b7c46954cdd32be00150537915170d878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3463fcab3b379a6cabf1fcad512908018008fedac56bff1b224650eb54371e4"
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
