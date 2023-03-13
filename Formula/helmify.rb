class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.27",
      revision: "0294e6b7124df932ed40eb2fa6afe2ab617ca601"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6daa4a383b512012b3fe41ab91b5fc5f739a242ad95b1b834fcad05f6ffc5a3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6daa4a383b512012b3fe41ab91b5fc5f739a242ad95b1b834fcad05f6ffc5a3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6daa4a383b512012b3fe41ab91b5fc5f739a242ad95b1b834fcad05f6ffc5a3e"
    sha256 cellar: :any_skip_relocation, ventura:        "4588dfdf267b46d88cab561d00f29f9b7006a5b80bb5cd3e85a3a5f55e0eef37"
    sha256 cellar: :any_skip_relocation, monterey:       "4588dfdf267b46d88cab561d00f29f9b7006a5b80bb5cd3e85a3a5f55e0eef37"
    sha256 cellar: :any_skip_relocation, big_sur:        "4588dfdf267b46d88cab561d00f29f9b7006a5b80bb5cd3e85a3a5f55e0eef37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "574a1bf9d5e422aae7bacc2ee5b9e5e89f252da577b148427473f9cc7b965b44"
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
