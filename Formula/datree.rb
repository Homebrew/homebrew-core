class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.2.10.tar.gz"
  sha256 "67d04ad5a29522f36b5545bcbc9f6199be5154dc6c752185f903b096baffb87b"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31d3b36647cffd7c5f970e2f7570f915bd49b269f569c9e5f81637a8eaaea7a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5404704cae3b5b607596b145d180e91124da021182337e61d948f430d0ed0a80"
    sha256 cellar: :any_skip_relocation, monterey:       "bc9826622bd0a1dcd6157a4cb9815b09e85549d9aaf12821f600ca4e8f51e496"
    sha256 cellar: :any_skip_relocation, big_sur:        "01991a3f748e918d2124e92dd69106f4e02b5347e08d751ae96523c464e898b7"
    sha256 cellar: :any_skip_relocation, catalina:       "d463e42d47796e1d3594b9f5a7ff73decf4752c3555f719f8cb22a776aaa14be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04c7a92ae0362798b8f77189d625ced8fd9d612034738eceddc1f8d21f222e18"
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
