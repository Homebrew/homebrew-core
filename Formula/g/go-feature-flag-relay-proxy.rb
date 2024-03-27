class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "f07a57ca5ceda06c976cc443ba2ff63c57ca970ef73436b2856c943c9e963be8"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "385ddbadc0c90342cea5319dd5a81123caeaabebfe7ec258d214b7f917673630"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fff390b8c92c52433a0c578cb790c98683b90e4fe56695ddcd5ef43f4a3b950"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bae99ba8f009feabb5bf2c1a8f6e7ec872b0e5784c359c4faeb0986321da6c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "26e5064e38b33fc513552fef18be9259f80b07f235258635e6d44f3e0efefda9"
    sha256 cellar: :any_skip_relocation, ventura:        "993ffd2addc566a015c326e92552a9544df08bf3a5d4efcbc4fc5ed48c868000"
    sha256 cellar: :any_skip_relocation, monterey:       "c5e21a223ce8d35ab61219e401cf38432cc94773440c07c9d67ba63e78d3e507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1a981336c3c89b3c9cbdea75f89716b8c9ce43862d039b596cbfa8caf7021e4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/relayproxy"
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
