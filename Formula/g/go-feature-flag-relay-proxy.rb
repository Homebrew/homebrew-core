class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "4d2ba7dc850a9011a6a56a172e495bc663d01892c3eb62dc61464c5ef019f129"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45f529923cdca48b6fcc4cea8672a2a208173aa74fefbe3e00c1aa51cde170bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ff941d96a9b9df3c029d22340574b6487747b8ee5efe3e27f4c6162187a08a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a01f25c40dbcd7836099898dd5b7894737d3072a307966231016bf971abdea59"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e50c014a98f90ff30b9092ef489f93ded30d3c6610e24fd57cdcef2f18ff117"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f99ddca821eb0b740fbce555828aae69db1b6e326b1fd7748451be3d44a722e3"
    sha256 cellar: :any,                 x86_64_linux:  "8bb7c46c8d728844ba9180782ec0fe72f7d8bd917f5b4a1a8593683143da2c99"
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

    pid = spawn bin/"go-feature-flag-relay-proxy", "--config", testpath/"test.yml"
    begin
      assert_match "true", shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
