class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.58.0.tar.gz"
  sha256 "d9f85fa7974205467ec7def1ee4896614dc8ac7ceb3773f5ead75481218a3785"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66a94458b5631c1333b34ba32ef0430d78c80d8cfbe1c87acced429790aebdcb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed24e784c73b0f1e60466a048098635b83c2a4cff12d20d707d538044ba8051c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6cd573ddadfad0a9b9d61287c4c4a63ec9de8a194c70bf02c83522dc0aa82700"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6891f025d72ffef14c2ece09df61c76521b9545c73cf5f13425997c3824dc383"
    sha256 cellar: :any,                 x86_64_linux:      "9512eef1128bbc4828c36f3886d16ced9cfbfc26ce00b267d519f3e457782778"
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
