class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.11.0",
      revision: "2f9bccf38ff06dd5ca5f6741351eedf8ba659ad0"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6a76a58385464a6a0d53ac21f5c43da2ccae98649da4d4727fc46a5df90f893"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6a76a58385464a6a0d53ac21f5c43da2ccae98649da4d4727fc46a5df90f893"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6a76a58385464a6a0d53ac21f5c43da2ccae98649da4d4727fc46a5df90f893"
    sha256 cellar: :any_skip_relocation, ventura:        "a5c97a6e690cb62e9027d272801c9028549386195712f2c4e01fd445cf461bf9"
    sha256 cellar: :any_skip_relocation, monterey:       "a5c97a6e690cb62e9027d272801c9028549386195712f2c4e01fd445cf461bf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5c97a6e690cb62e9027d272801c9028549386195712f2c4e01fd445cf461bf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c05cbaba9d43d1599a37833036aa1ce4dfa94ce5c7ed31fff202c45395846f58"
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
