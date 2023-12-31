class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "d65c42f26d7d498a57c2b601d3e528f251ea2823046c27c1f2ae37138a9dfab1"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35ea1afeaee50eb4f29237b3dc16667296483b93ea9a5a917bd80a25ff8c53f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2254ac3ff8d4e4253c77c35c88395f6bbe9b55bfe775ef1cfe6282f44afe2b30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e602953aba83fcc4b203bf54d8db20c8376b34b5a329d0060b42f8d2827811bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebb77912fbe3e981f782aca50d0125c7b79f67d7e4ceef2a2cdacef3702e9764"
    sha256 cellar: :any_skip_relocation, ventura:        "f6c2be43ab8293feadb00c66af6941566c68feec31196d8f2b3fbf475d5bdd67"
    sha256 cellar: :any_skip_relocation, monterey:       "9c6df9f5a491b3c4453dcc9651e6db45c1e645c85590780696d693735ba2faa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e871b76ce29dfeeef542f66c973b8b5bcc84d3ff9d55c736b753fe17588220f8"
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
