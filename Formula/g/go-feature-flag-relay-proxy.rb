class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "6ba4279a83fbccfd8cf234141d224cb2694c70bbc3b74df0fffd1dc8c462efbd"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "242c01101068eb14bdcdd0c8270121e1b359207c6c0fb4034c072905956cf3d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50504791aa1aefb88b5be527ef0c893a2a31e037ca70e19f54019f19d527ab1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4f339b20d0f3736eda8f9dae2f5f768b201af66d9b962d59c748bfe07c002b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b133f43d13161e69e3f66ee7bf207bbda5d55b39adf81cc087518cf8a3d7a38"
    sha256 cellar: :any_skip_relocation, ventura:       "640f12b147fe0c8a376f6c48eccfeadc9383824093d43454071a6b70af6168e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d24f54c150ea48c55fd9e5efef33a463aa24c2ba34b1db67949a634760a97dc"
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
