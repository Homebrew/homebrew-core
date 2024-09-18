class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "ccc515ba36ef88cf4fd1c51b693071034d197836083ecc49a8a4a881cc30f0cd"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07cecd11c6d60a2cb776dbe2758257f8bdcf6f9940647144eb32fb6ae0b6f3b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07cecd11c6d60a2cb776dbe2758257f8bdcf6f9940647144eb32fb6ae0b6f3b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07cecd11c6d60a2cb776dbe2758257f8bdcf6f9940647144eb32fb6ae0b6f3b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b5cbd7904d9913c5c4dc506e74cdd26d7b3fc7b25e1deeef4b4ea3696e2b86b"
    sha256 cellar: :any_skip_relocation, ventura:       "9b5cbd7904d9913c5c4dc506e74cdd26d7b3fc7b25e1deeef4b4ea3696e2b86b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc5ed0e9b359ee0af0e6f4880cf6cde3f20c002761d59b70b9d098d60a18df18"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~EOS
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    EOS

    (testpath/"test.yml").write <<~EOS
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    EOS

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
