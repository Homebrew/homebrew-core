class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "1781ff09e8d7d050da07a1c27dda1af6d06e8dfc4d7f0a9bc179950f90c10693"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f365319065990545f9b4e53803b887e8d0c26460c88f80b68003e14ff288727"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdc26563c2829c98d893e7c7ccd2f28d90137a6c2515f714db04d747ab5beb0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69d8a66769358aeb81a4ba14338e391a5b33c0fc46984e2d5ab208ca79d2b009"
    sha256 cellar: :any_skip_relocation, sonoma:         "5633a032a46a7c06e36e5e4fb4642cbaee36326cd170652b562a3d118b007d27"
    sha256 cellar: :any_skip_relocation, ventura:        "4bbb0ee0e602329d703dca6dd4a1de6732c49d707a825c8756edfd8ecafaf564"
    sha256 cellar: :any_skip_relocation, monterey:       "4cc471c6f1396df782abac51328dfcc48c60057a83f78a9e594360b3092cb8ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bbf1fe67691af91395590f7b3aad8432e5008931f9ec0d32142736048a8e147"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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
