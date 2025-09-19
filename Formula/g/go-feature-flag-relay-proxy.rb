class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.46.0.tar.gz"
  sha256 "53fc63c74010912fd7f7484e0f7e470c7578dc3c1bfb0d098949a9dafdd6b85d"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd85e7a259dbde3915e77da7373a3c5ebc992e1c6dbf701f812a59c4dda21a6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b6c2f5037d4b6c89eef49707fb8acf1d46a3e49cb10beb5723f2568df80356e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "364fad3d1e64db63e30042156def72351376a5283f39627b8a49208b6b696fe2"
    sha256 cellar: :any_skip_relocation, sonoma:        "584d2f063812530b656eb5e3feccfdc48418e9fb5d6fbad4339a8debe7b46744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffce476f12b9f69a2f25b0c9413b6519921e7e3d4a0b352d4b6289f2b109df23"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/relayproxy"
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

    begin
      pid = fork do
        exec bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
      end
      sleep 10

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
