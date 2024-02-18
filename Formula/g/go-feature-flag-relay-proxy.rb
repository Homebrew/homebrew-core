class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "7a78871a5d4cff2f28128c13ffbb51d29a2f10e4c8b5e9aafe8f41a3f5ea219a"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf2aa2dc9c2282598b5c9247bf2b9784e89be0d0aa82c04a1bc9dff40f5260ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3987ff6e47026c57b23f2cffd5102d6b33c4d2ee04d507aae1eeb66c84332841"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b15a1c2d546aae46cc166f95522de11b5a5ac832a8838be07c571e3b5e90f60"
    sha256 cellar: :any_skip_relocation, sonoma:         "607af18121bf1de2c190370cfdfb3f1b24844a3160972c5b7d82daad28e17228"
    sha256 cellar: :any_skip_relocation, ventura:        "57e13b37eeccd93a07426b6c11433db196a33cafe21e92e048e3f65d6097b1d7"
    sha256 cellar: :any_skip_relocation, monterey:       "1e8d3be55090b3ef9fddb7873b370d93ffb1092bf842bd187f17aafae19b7404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6975831a2bbdee979e9bfab3748b1992b6fc02d76a7b5ee698a1a42b40c35fdf"
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
