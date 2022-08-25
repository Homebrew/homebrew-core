class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.13.tar.gz"
  sha256 "7675c4c79623470ae2f48742f4b58290a306a1879dbac4341c7cd693461ca409"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "802be1548378ad771e684479ffc66ddc84dd42e4e2dbe7dbaf5f9c677a52cc58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86426135bff8133524ca89601e0f057c9a1207bfba50234940521ccb2fed178b"
    sha256 cellar: :any_skip_relocation, monterey:       "779c4a937ff4436fd00f84238e2f61b77b9cc496ee8734c11a37a12762b070af"
    sha256 cellar: :any_skip_relocation, big_sur:        "7db55f90f7fba69f66cba1e62bfeb1a9aa8c38fdb05bf901c75afdc834638c15"
    sha256 cellar: :any_skip_relocation, catalina:       "ef3a34a83c28e65baf27f7cc23732bb38d3618d240401a1b0cafeba9bece4644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ed60af5e183f0d5bba4401500f5afb72331990e975d75e982cd1ba71d67fd91"
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
