class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.55.3.tar.gz"
  sha256 "c043dbd781a3dbcdbf1ad71a0784d392b811031344f4de40026f99daec1f6852"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9a9b2364eb624dadef4bc5466e32dd1a9f3bdb2136a358cbbf0bf666d58a019f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29516093d21838e17e038d28cd2144a0f9479ab74ebda2b33f8041e6ff2ea60a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e06c560ef3f5c0f8676bfc7e6292fa99135c03625bd431b32ad966369e25813b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "a8b7c7cd4f874156a9b22d47c18c7da0fd2fe003ede23f03352c870c01fce91c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0557accbab025d1fead09685ca58ebb010b8e1388b1cffb5731e0309eba694bd"
    sha256 cellar: :any,                 x86_64_linux:      "d8c8f7ebb75d830d84661ac4a7e76bff45d2c0aab1586899293e133e6db53498"
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
