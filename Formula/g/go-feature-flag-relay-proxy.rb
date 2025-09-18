class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.45.6.tar.gz"
  sha256 "586ab64a7419947eacd00c63b3b682758864011ec937cd4332fc011374fd1cfd"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d3fb9636c922a126eed107aef4854f2a2334375d1db1731a1854c834ff099d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72d7d00e67067e32aae43a78b85732e8816de051bf0ceeec847f204cc0324258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26226383d5ce484677926c85b999d2400155d29a788e8c30055fd9cf52ba51ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e6dfacab3ebbbdb124cbf71fb5765c890384a0b726fe2ecfa2b0789f5b761ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b8af7e9efd7507c7533b2a2574e0311c9d674231f794162cb38fc7e1c968ca5"
    sha256 cellar: :any_skip_relocation, ventura:       "9a19c383707075a3e4a03dffea0be3164f628edbb3d11b06e72c1a8b1ae7155f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0562f22ba6f6437ed48ab5a7b6e6e0296497d42c8c4b0d4553d56825cb1b3b1d"
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
