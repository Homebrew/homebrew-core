class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.12.0",
      revision: "f568822455302b4dd61bfa7da63303cbc41080b1"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b125b418ee50a210dc65401692f1a4a1eb5e8cceb19a78de8419faa322731c5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b125b418ee50a210dc65401692f1a4a1eb5e8cceb19a78de8419faa322731c5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b125b418ee50a210dc65401692f1a4a1eb5e8cceb19a78de8419faa322731c5b"
    sha256 cellar: :any_skip_relocation, ventura:        "514d6fb51258cc441818747b61abbc827b0ae86d082e473864cc788be3dc3aab"
    sha256 cellar: :any_skip_relocation, monterey:       "514d6fb51258cc441818747b61abbc827b0ae86d082e473864cc788be3dc3aab"
    sha256 cellar: :any_skip_relocation, big_sur:        "514d6fb51258cc441818747b61abbc827b0ae86d082e473864cc788be3dc3aab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edb10994ae3b452d350d6d725b7b440130966713d6781008733ae1f5feb830d2"
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
