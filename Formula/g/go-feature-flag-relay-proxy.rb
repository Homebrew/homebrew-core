class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "2c833fdaa91cd7b95882a8aca8c494c96b690f9da30d2902d7798490122d72c9"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2e3241f72bd75ae1f1eee4ec0e57c869e8b02f689b6fd5a0ff4156883fdc747"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2e3241f72bd75ae1f1eee4ec0e57c869e8b02f689b6fd5a0ff4156883fdc747"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2e3241f72bd75ae1f1eee4ec0e57c869e8b02f689b6fd5a0ff4156883fdc747"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd423bea653dbd17de42d544fb28e681ca8b84436d067693ac4a3fbac5d429eb"
    sha256 cellar: :any_skip_relocation, ventura:       "cd423bea653dbd17de42d544fb28e681ca8b84436d067693ac4a3fbac5d429eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc8fa1f510487dc9eb05641fdbd16ca06d13c3e36647fddb1d4e824b1f7aac59"
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
