class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.55.2.tar.gz"
  sha256 "bf5448a6110d21b673456450abfbda2f08720d016c0f0632be97200c3d0d12ab"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fa93b987615ed7afa460b48c229fb3eef57a4107dd43272c14fd88c7cefb373"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "169f63f2b67670f94facabe230be3536381253d96c16d98ab40708907498bbdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1534d919536099e0bccd185598f5528f140c8d8199d11ea5fe3e913bdd652540"
    sha256 cellar: :any_skip_relocation, sonoma:        "d23c772fd2faff4878057680f93d0c08b34cdd8f62adbf599d3efc01933ad621"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d45b709a4bf075a97c0c3293bd8fb8e54422cf436cd075c1815f7808f1dd88fc"
    sha256 cellar: :any,                 x86_64_linux:  "8494a9e01e073146ab0d08a74ef2aed0fcd4c9c8389678df23779c348c51810c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/relayproxy"
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

    pid = spawn bin/"go-feature-flag-relay-proxy", "--config", testpath/"test.yml"
    begin
      assert_match "true", shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
