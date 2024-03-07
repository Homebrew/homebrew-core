class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.4.11",
      revision: "2e9539cb5dfaf33b8c9741c1fd5deddc83e9db41"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ad91f2d29816ea94fa7c208b74ece6b51f1bdcde1d29b45b3566a441193997e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b64fe9432264028960715c07462e92fda198cab5d433ac73a1c3204ef65d620c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "026c6700f67330e2eff963e1371e64006300152609ec908475e77fe057d77746"
    sha256 cellar: :any_skip_relocation, sonoma:         "e318c85300fc0b5a2fa721b3bf381e600dfc3d45871993e49a1a4c07eaf47850"
    sha256 cellar: :any_skip_relocation, ventura:        "4046112d2064ad07a7088f8d68a9da7289dc1f6a44563da5c7fe5ebe1dab7c81"
    sha256 cellar: :any_skip_relocation, monterey:       "b81ceec438032376a62f15fdae49e9b00b90e0d16928dc9d43c923e43c8233e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33af44a8959c2a06dc874f819a91600cb1a0034d6107fdd3a0f08649d11efc83"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/helmify"
  end

  test do
    test_service = testpath/"service.yml"
    test_service.write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    EOS

    expected_values_yaml = <<~EOS
      brewTest:
        ports: []
        type: LoadBalancer
      kubernetesClusterDomain: cluster.local
    EOS

    system "cat #{test_service} | #{bin}/helmify brewtest"
    assert_predicate testpath/"brewtest/Chart.yaml", :exist?
    assert_equal expected_values_yaml, (testpath/"brewtest/values.yaml").read

    assert_match version.to_s, shell_output("#{bin}/helmify --version")
  end
end
