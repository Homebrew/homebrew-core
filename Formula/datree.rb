class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.48.tar.gz"
  sha256 "fbaf316af55b459c7a7c45a2695903804f3310e692ccbaee043fcef8cfde8951"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5bb08208fb23b4ffa62c63401c2351340dc3f90eb889ac1629ef73ce5b77999"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2080137685fa308f9e83d2a79e62e7cf9e5b8f69232272cb3d488efd8828f52"
    sha256 cellar: :any_skip_relocation, monterey:       "2098bd15bb9f272295532475326282137e849d370d50dab734c8d229e8ba933d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a09d3dcacb040ad240cbf674f9ca2d6a2eeacc76cefff8b537eeaef1c07b284b"
    sha256 cellar: :any_skip_relocation, catalina:       "0c5268040a18c0111d52f0184d394843e0f555e795b2bb9c35bd9016c189bba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af48852873230437add51d6468947a8130ce4e97c71db09d6b27abdab0c0959c"
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
