class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.6.0",
      revision: "30cfa9d3a3c34673fcdf5aed5c04e7ac887ff5da"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c32bdc963106a182264bfe234e609af2212d360c169b4c41ffca6059e5119059"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c32bdc963106a182264bfe234e609af2212d360c169b4c41ffca6059e5119059"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f53ee5b8dac0b829a313a9a2875f81c05de18479b1540a84b9f2d9826a48f3cf"
    sha256 cellar: :any_skip_relocation, ventura:        "bf7d4c8b77062a63d77416f7137a375c65237ed6f1dead3b2211a7e2dd3aee31"
    sha256 cellar: :any_skip_relocation, monterey:       "bf7d4c8b77062a63d77416f7137a375c65237ed6f1dead3b2211a7e2dd3aee31"
    sha256 cellar: :any_skip_relocation, big_sur:        "00c7faded3f723617f53d6946935c41e53c33638904ab3ccd75135c4423bf2b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05b2283290e474f0dccee87547506516071ada863d782a432b547d0b251686ba"
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
