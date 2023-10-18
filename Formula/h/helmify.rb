class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.4.6",
      revision: "aace0334e2e65744f781e897f124653738c4c7f3"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46feb0f30c673aa98d4302d561cbc4879006cdb40170342235a4dbd3853650d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39a89aaecf8c1c5b230cd10f51520a74613cbbb01456cce3895cd3bfcf3f4aef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8dc4d73ddff327340c534396ffff53fa0365c4019444ea1d3d7c9a8cae84656"
    sha256 cellar: :any_skip_relocation, sonoma:         "aebaea0e65f0f73ab549570b0c418f62e182de7b297edb73b7e1415dc118f160"
    sha256 cellar: :any_skip_relocation, ventura:        "059d994055cb435b1693137a820769ac337c97c221d78f4d7ec6cd5828d35355"
    sha256 cellar: :any_skip_relocation, monterey:       "08da678bdd545c4ed6da30a75aedc85ce5ba1d936839908f53dec31477785da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec2c3998f7d05bcc10d4db455d4f899ac8e53f1052c08c876ddd4d3a6c6203bc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/helmify"
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
