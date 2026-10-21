class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "eb95ff306972e4262980d94832b4199694e73ec648a90f52df9b2294c86cbafc"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58ab1a001b22ed9cb666bb65600f153c4350ae8aa3c13c9dbf9dde91dd3e9209"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f674c66e45fe98ef64b535ea5368c86d80de9df6a4cb7b683b07f4c2226f946"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "25d5127f31b8888c6942b95b300a6051aa6cae3db2a510c7cc969fa0686ed29e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6be6bee7d7f7237ea799f3c879409e96c6909553e90ebfa6dde4ab8e27c723ea"
    sha256 cellar: :any,                 x86_64_linux:      "59f1e5f1393a026057c6caec4fef561e3d1f8da4f57191180f8ce218c5cb189b"
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
