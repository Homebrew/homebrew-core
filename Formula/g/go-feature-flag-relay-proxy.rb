class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.45.3.tar.gz"
  sha256 "51082f96ca1e9d88fe020f6862f71adcf0d00f591ebf91c5615fbd90ebc5e13b"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b419b53e5a830f57f82ef9f93b7ef8ffda8146a70b04f2afdb5749ca2002644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8c5818390b013a92da80ba5d1a4ddc2b5176009748a1b6e87838e33315344d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f29cd834ff6000a1aabb02ae840cd9c1470cccc87b42f65de4c7aaa5a9e8c756"
    sha256 cellar: :any_skip_relocation, sonoma:        "6efce48e5830db6143560714476badc17bf3e8b44dcedf42ce3a44f06f37fe00"
    sha256 cellar: :any_skip_relocation, ventura:       "9a9c22712d08e214c741762f08afabe66fca96409ccf89f37abc1b75c49a0578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b05f151f3f8e6a5102437ccc6689d94d5011cfbb46bdf9ea3e5793c5c907cc82"
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
