class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.59.0.tar.gz"
  sha256 "938ee8d61503200e8e75c2b8eb307132cd85ed2a41da5b7df012ca6c9d792cf3"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7f509100e05b247a3e4fe9ae29da8ec596dda81f03bab9f1c1e3126ebb71f2bf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a047aad011b1c40b5d07bc22e278b20c128dad30f6daf2db75713ac88478994b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f1825b93b3cf7bb809739f8bf01c2a12a1dc1c380cf92e8bc44e739dc735d4b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1ddd67416cef701a4b76779af1092dd0f5a3206f854b32a87778c346c9708e42"
    sha256 cellar: :any,                 x86_64_linux:      "81488d830c2a12328458be13b45a4a41391f1594ab9556182f7b19b7029aac9e"
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

    pid = spawn bin/"go-feature-flag-relay-proxy", "--config", testpath/"test.yml"
    begin
      assert_match "true", shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
