class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/v5.11.2.tar.gz"
  sha256 "9f92a150d80de7c152369e8f03cfffb9b17b5d9f67896cacb504f1a59566a5ec"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57995f33458eb17935d82b5bd338c9de60adce5fb18a9a1915fa0ae254ec1954"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3318191607547959c66988251db066325848aa9e32c5338fcc1c49795e14fa33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "736ad336ce98702175b2c3a019bed7923b6e312dab6c1bd34cc9607fea90a3a0"
    sha256 cellar: :any_skip_relocation, monterey:       "be23ef2a0ae97badf56ad4472068c4048f04197097c70682f5bd87e2603e2539"
    sha256 cellar: :any_skip_relocation, big_sur:        "18a428637b47ad08b419d4534d925dcf3dd0f1c2f5ed29f07c7caca3ebd9c8fb"
    sha256 cellar: :any_skip_relocation, catalina:       "6c398e0471e87c67e66db9220aff5de8480c27bbef7d7cc648c507314c727190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9575a2084e7e1f20dc26be4649ff926e0e443d4d30ea878e701013252754245"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/pluto/main.go"
    generate_completions_from_executable(bin/"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~EOS
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    EOS
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml", 3)
  end
end
