class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "f07a57ca5ceda06c976cc443ba2ff63c57ca970ef73436b2856c943c9e963be8"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48925e62cc13723f546d11adc9a2b896ff39b5e5beb6ab4eac474a6812daddac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b0370fee88a9935315331095fbde9ae1644ad673baa31e43ad6fba096009192"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b4570c04f60bdbe46e4171b7f2cd07af3641215d8dba88667c38fb0d3424084"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ac8899e983805d2362b0fe80d32e1923fc42b38edfcc40d70a926ebb549d0a9"
    sha256 cellar: :any_skip_relocation, ventura:        "72a7a7969a648b42593a94838f9d668e39c9c79001c029ab3d8ee5050c5b104f"
    sha256 cellar: :any_skip_relocation, monterey:       "c2354101c5aacf537b3eb8ec5ea114b728ae4b3a53e21ee9485d3690d20899d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd3eef8006773b6870cac21cbf0e18385e4dee9b48d5a7e82b2c5ee8872b70d1"
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
