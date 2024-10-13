class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify/archive/refs/tags/v0.4.14.tar.gz"
  sha256 "34a84f8c49f7a7385ad6a0b7f1044675a72951696989d9e35de9e16ea7899b08"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "80e631b902fff10b11e0bb3fe6223cd2dbfb694a3428a3b019daf1db95e210c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80e631b902fff10b11e0bb3fe6223cd2dbfb694a3428a3b019daf1db95e210c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80e631b902fff10b11e0bb3fe6223cd2dbfb694a3428a3b019daf1db95e210c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80e631b902fff10b11e0bb3fe6223cd2dbfb694a3428a3b019daf1db95e210c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "70af2de82629c9d4501db4c9d493d27e29e89ccefc11de57e122420ca7a88e48"
    sha256 cellar: :any_skip_relocation, ventura:        "70af2de82629c9d4501db4c9d493d27e29e89ccefc11de57e122420ca7a88e48"
    sha256 cellar: :any_skip_relocation, monterey:       "70af2de82629c9d4501db4c9d493d27e29e89ccefc11de57e122420ca7a88e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98caa383ba0179fb631ebe07e86f02b65278d0a1605f50ebcfc3f5323a36dcad"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=#{tap.user}
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
