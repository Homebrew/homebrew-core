class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify/archive/refs/tags/v0.4.17.tar.gz"
  sha256 "81ea18dcbf1f135c9fae8c3502cb845dcfd99f2ead7234f03913ebebf563beb7"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1245594585c7cde444edd84dfa10a42f31bd78f853153ac7bc7cf6d4dfe72132"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1245594585c7cde444edd84dfa10a42f31bd78f853153ac7bc7cf6d4dfe72132"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1245594585c7cde444edd84dfa10a42f31bd78f853153ac7bc7cf6d4dfe72132"
    sha256 cellar: :any_skip_relocation, sonoma:        "906399dee463915b51a296d41708920370efbf7727d67e3750923222ad985cce"
    sha256 cellar: :any_skip_relocation, ventura:       "906399dee463915b51a296d41708920370efbf7727d67e3750923222ad985cce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b531a6283d42bdeb97c354d38ed75995127f1219ef4dc68aa860038bdc31310"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/helmify"
  end

  test do
    test_service = testpath/"service.yml"
    test_service.write <<~YAML
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    YAML

    expected_values_yaml = <<~YAML
      brewTest:
        ports: []
        type: LoadBalancer
      kubernetesClusterDomain: cluster.local
    YAML

    system "cat #{test_service} | #{bin}/helmify brewtest"
    assert_predicate testpath/"brewtest/Chart.yaml", :exist?
    assert_equal expected_values_yaml, (testpath/"brewtest/values.yaml").read

    assert_match version.to_s, shell_output("#{bin}/helmify --version")
  end
end
