class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.23",
      revision: "a5edb18a2ecced632c9396613fd4c1166c7ce79e"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "268a5a478b23ad908a20596b1b086c38397dec9b6b1d483db297eca9d4dd2200"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6636ac012cfbfd9fa3a22263a48826e547ab947cb708a0df3441d93165a232fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26e34a6062402aea1ba58b23583f20ca3c74959259742ced934575da1667ab4d"
    sha256 cellar: :any_skip_relocation, ventura:        "179c84f4003a7a37b2ce75f27e4df9c4153a0e305c1949627bef6ea83d2596c6"
    sha256 cellar: :any_skip_relocation, monterey:       "12338d56f6960f9cb6b086f24ddb48cf675060610164442ca867ab9e0023492d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a7f9af908d751c373d167982f627fa9af0da2d90ecc2b87af5aa51ea22961b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d658b9bf6a1f00a353c4a566bd20bf189da14b1a9b3e4c8b4e926a5fe316daa3"
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
