class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.10.4",
      revision: "792f6aac85585fcb6db5e50de8c59011c98bf0c5"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1132ee201848c02616a585136bbdd0ad1e51b9517cee4e14ff906d5076bb7a53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1132ee201848c02616a585136bbdd0ad1e51b9517cee4e14ff906d5076bb7a53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1132ee201848c02616a585136bbdd0ad1e51b9517cee4e14ff906d5076bb7a53"
    sha256 cellar: :any_skip_relocation, ventura:        "0ae35f49a3adbc56b80e781c470fcdb2f30599616174ab4d9f092891b25da167"
    sha256 cellar: :any_skip_relocation, monterey:       "0ae35f49a3adbc56b80e781c470fcdb2f30599616174ab4d9f092891b25da167"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ae35f49a3adbc56b80e781c470fcdb2f30599616174ab4d9f092891b25da167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0840702a71b187fb5cf165f1c3e5afcb66367e6b05a9b73d63b87a098123ad40"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/relayproxy"
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
      sleep 3

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
