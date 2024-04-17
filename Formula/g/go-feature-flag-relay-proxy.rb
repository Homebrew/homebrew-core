class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "dc0875507ac4ddafe392d5b8d794fe7f1ffac971ef28e00afa7dbb3c6409835e"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b63de56db95aa52ab001147ba1f420ea2d14ec7148559640ac5286e1d79cd472"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d86482393fcdbb90ace41aade748632d0fd5380b5bcf9d113c255debab689aaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fe3c30663bf7b7affc2552745be1b3f60d05aac8df0bbc7c0d83b43f6b98580"
    sha256 cellar: :any_skip_relocation, sonoma:         "33117782eed09045c9abbbcf23830e059fcb7c9bf2d16a2d6e7401c3b8c0cff3"
    sha256 cellar: :any_skip_relocation, ventura:        "5431e028cf97e74d0a75ab243b1070792b072c271da094d80102e384701263d2"
    sha256 cellar: :any_skip_relocation, monterey:       "87fad538e8aaf6ad310afae27a576208b71e89fda0757c5963b45e42c92b8934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "971cbfd3317cf51b91276d38a97a8ab06ad8800c05bec53467de48ed324bb77e"
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
      sleep 10

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
