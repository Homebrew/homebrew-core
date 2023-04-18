class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.4.1",
      revision: "9e709ee1587ab637bf811837213670c1f1125ba4"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c33b67a6fb012aa16787ee93563e14bea7053b751558a5a38688d60fd2f518b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c33b67a6fb012aa16787ee93563e14bea7053b751558a5a38688d60fd2f518b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c33b67a6fb012aa16787ee93563e14bea7053b751558a5a38688d60fd2f518b3"
    sha256 cellar: :any_skip_relocation, ventura:        "5dcec4b7474cc976f0b0f3e9b10b11f50e8ddcfc2a76cc9514e973be26c997f0"
    sha256 cellar: :any_skip_relocation, monterey:       "5dcec4b7474cc976f0b0f3e9b10b11f50e8ddcfc2a76cc9514e973be26c997f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dcec4b7474cc976f0b0f3e9b10b11f50e8ddcfc2a76cc9514e973be26c997f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0f31bb377683851ce4605c06375b7bf09b75d694f5370168d4355b7bac16bb0"
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
