class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.58.0.tar.gz"
  sha256 "d9f85fa7974205467ec7def1ee4896614dc8ac7ceb3773f5ead75481218a3785"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a1e7b786b799e47404d4e51feb1c43af254ac6400b709d39e76074da11dc9b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "88588a691564fe40543b058f20e4bba18ac5b862909db1016c9d6968f47e4163"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "edf511fa7bdbf6a71a4467a41bb4bc5fd2f722320cb237c65fbc1edd15945a4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b69787cc5921bf53f2f7c14829c310aaef84607b9d9172d5eb464f0611371a67"
    sha256 cellar: :any,                 x86_64_linux:      "b2540a4459a96adfeeaf3852880aafd1d68ee427ae9f03671562d78f86c4667a"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
