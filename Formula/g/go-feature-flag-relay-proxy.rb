class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "e4c7fc645709a3bae41f9c61ba150999a0a81c160f5d266d028030e276f3d08b"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bedf8a6877d7509b845d7e8f9fd3b7849154a78467b1cbb358b63ebf50504492"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bedf8a6877d7509b845d7e8f9fd3b7849154a78467b1cbb358b63ebf50504492"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bedf8a6877d7509b845d7e8f9fd3b7849154a78467b1cbb358b63ebf50504492"
    sha256 cellar: :any_skip_relocation, sonoma:        "abf5a9297e41509a58ab014e9c90ebf6a1e92806d9b5a62aa23efaf93e0b3c2b"
    sha256 cellar: :any_skip_relocation, ventura:       "abf5a9297e41509a58ab014e9c90ebf6a1e92806d9b5a62aa23efaf93e0b3c2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b541d657e5cdb5beb01cfc314536ba5dae3c5abfe3a83b8587d4d616f071aeb1"
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
