class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.44.0.tar.gz"
  sha256 "00a1a3987174b34e81c9cdfdb95120794cb24907015a171e174523da3e6c66f7"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d8443e1a433c482e7c1bdda6bd1bd8b3658369d5ea332de03b66e85d7c5ffaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "424cf57b8642a33d4ba54cbb55b8bd71be258909d11b0549b6633e4864c05791"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f34daafe0cb0eaec194baa0aa2b191bbb289fc5abb3da87366684bdd3caf9cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "15608f4b256668e174c3e06b3b90bb90cb8af7dafad6eef42da9017eefa25e72"
    sha256 cellar: :any_skip_relocation, ventura:       "5d3abd169f8a2e1f4da49c227d2ffb9a466b2a7564f1dd5c37556714c45b5266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa1787651a69c0e7223a30e7fd166a15548bacb59d6c665e1e9de8a94859ea62"
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
