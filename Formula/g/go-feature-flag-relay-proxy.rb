class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.58.1.tar.gz"
  sha256 "11a570a1d34d91ddd8e07fdd0444c5a39af7b8a9550a0adfac5f2848dcd54f71"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e962af1744a0bc9cfc56b0a83a6a2a59ee99dfef0b8003d4ae88df14cd4d1a90"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f400a34354523fcca7a6cf2e8986bbbd391cb19d4431500bf2576af8ffa4994"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "85e1d8909ae85cf0ab834f557669b97b4ee59bcc48b45aa5ccd5a2a89bb6c409"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0290f6775a3b8137cf4d248b039c89071712b56416a9eaf661f19dbcdd1ed9bd"
    sha256 cellar: :any,                 x86_64_linux:      "e1f21ae87f83b7c8f19035545512361c90133816a30df2707568a00a3c07e327"
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
