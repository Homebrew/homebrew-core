class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.8.2",
      revision: "d0e1789908aa1c5be9cb122dcd73642a69773223"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed9c2d63893ea2fd819053b1b4ca53a0148a313e05c460ee0afb4710a2f553d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dda5a79c56f832f06e5a22f9d0f30d84dbac0e4baad7891ba086f392cb56defc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed9c2d63893ea2fd819053b1b4ca53a0148a313e05c460ee0afb4710a2f553d2"
    sha256 cellar: :any_skip_relocation, ventura:        "44418709d527f87de958f95c6bc0df76e0559c78599d79ebf80baffdd81c9451"
    sha256 cellar: :any_skip_relocation, monterey:       "44418709d527f87de958f95c6bc0df76e0559c78599d79ebf80baffdd81c9451"
    sha256 cellar: :any_skip_relocation, big_sur:        "43f2dc91afac8a3ed785821808f80ccff73418b932044a421e4d4d4d8c18afab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9773d866a39cdfd5259ea45ba8073b6262b35fe0ccf145fbb27d530f405c1ee8"
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
