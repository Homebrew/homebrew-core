class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "7e8ffe09d361752d1660dcbf085f277496bb21b1c01b24dfeffeb6dbc2d970c3"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1e59384b24239c84551724cd3393163e0b74b16a566b25295abba8aac6c97b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "450e0f2eaa3e39929cfcc3cc018475ccb7e263d1dfef16933859f9ca52acc788"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e6ad9007410db2c1066f59d76768a6903a8e9403b2fa2b9a810cdbdf951a3f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b58ed0f56b78732b5d680bc2d0c69c201f83fc155e2faad7eca30832cb93e81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57afc08acaad1c668eddeb386b3f46936262324651d8a6dd7cca5d29b9eaf9e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55bf0d84ed813bac1e3161183074f04e1e018877bb85d53a26161fc1cfe83783"
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

    pid = spawn bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
    begin
      assert_match "true", shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
