class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.5.1",
      revision: "b4120c73dad7ed27a069768646672b0a8b8325d9"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13ed64bdf45257ce8a4f4d6c487621ed52c746e48e3393ae9dbed092fd874066"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7144cdbadf47e406620bbeddebaf7f4689ba75b33a055c644627e6e3addcd529"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13ed64bdf45257ce8a4f4d6c487621ed52c746e48e3393ae9dbed092fd874066"
    sha256 cellar: :any_skip_relocation, ventura:        "661d4168dbcb812d73adf648439bca3c8e469414643c7c4e8ad1a5492f71cf13"
    sha256 cellar: :any_skip_relocation, monterey:       "661d4168dbcb812d73adf648439bca3c8e469414643c7c4e8ad1a5492f71cf13"
    sha256 cellar: :any_skip_relocation, big_sur:        "22f58d275c8a7e43a39f3a9cedb817a40747aac820b8dc416ed0bcfff381e764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1bb6e99f2dbea7b7399613f82d7865a5a54d73466207537125f337df63cc061"
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
