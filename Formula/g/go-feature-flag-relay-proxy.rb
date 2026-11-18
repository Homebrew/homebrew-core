class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.59.1.tar.gz"
  sha256 "d7f92043b71ceafdc11aa34c0fc6e1fd29e7702f42f7f157af51818d4b0583fe"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10937d0e963113866f1de0634d3fd69404946afb89da9a26a4afb6cc7ed01e1c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "977b7b67a46f59c3881b49c25988c65580845a96f4644fcd92fa5ddfe4758515"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ebb55a3d9450255935724946cc005dccb67eb3317285a42946867507b8d76e62"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8ee5a131d3204e0f17f9e56bbfc89c8a66486e60f33d79c9538da12041c07c19"
    sha256 cellar: :any,                 x86_64_linux:      "a1b543eb10c91df34d33d2155fe4ef5821057edaec7760825595b52ab080abbf"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~YAML
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    YAML

    (testpath/"test.yml").write <<~YAML
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    YAML

    with_test_process(bin/"go-feature-flag-relay-proxy", "--config", testpath/"test.yml") do
      assert_match "true", shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/health")
    end
  end
end
