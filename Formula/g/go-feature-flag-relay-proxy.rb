class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.46.1.tar.gz"
  sha256 "a5e58a52ef03dd3567c356247c00fffd73b54a203782d0e8626e9a5070cbfc63"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f30c8911aecef63d591411e3aea4a097c67699d4b8a3aa83d18a3e0aa83e20e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fd0209e761f5e38976516b990d64b411db21dea072d8173880941516bd16bef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65fe86d2d9965cdadffa15c6f552809e9357b89fd3b5932b3a0bb05a144a7f1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7197d49bcd05ddb0d3def9a4207d8b404a6156f24c48c809034ed7ee8e98a735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce2f27d13b9618ff88a9836ad4d77d912d59d543443678254884c694a3a26203"
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
