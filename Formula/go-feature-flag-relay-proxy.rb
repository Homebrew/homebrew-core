class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.10.2",
      revision: "447fc9f4dab8018d4c6f7569e0c113c7744d2067"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90505ccd0fcfcdcf61567b852ddc959ebe36d1c5d736c641e2050db80d843a66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90505ccd0fcfcdcf61567b852ddc959ebe36d1c5d736c641e2050db80d843a66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90505ccd0fcfcdcf61567b852ddc959ebe36d1c5d736c641e2050db80d843a66"
    sha256 cellar: :any_skip_relocation, ventura:        "a3c4c948cafb9eb0e0311c1c00a0b15517f9ff7fe15dae5de2f1892d8ec71174"
    sha256 cellar: :any_skip_relocation, monterey:       "a3c4c948cafb9eb0e0311c1c00a0b15517f9ff7fe15dae5de2f1892d8ec71174"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3c4c948cafb9eb0e0311c1c00a0b15517f9ff7fe15dae5de2f1892d8ec71174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c89b307402a44fa0b78495cad850d5ac7f6524fef3bd6623bee5210f2da4650"
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
