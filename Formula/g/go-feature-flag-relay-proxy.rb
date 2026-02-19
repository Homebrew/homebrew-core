class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.51.2.tar.gz"
  sha256 "2d98ffd0b7bd979726e6674420eb6f7d8f236b7c4ed260bf862ee7822bd84653"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03c9ca43b166d415ca504ddb0273a4bad14d4f2dc813580272f3636a42396180"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb70a86ab0c70a1e1fd28f480eaeb2c393666a812b5634594836de9b07392cd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebd85d835f938c30b01d8a14c538b3ad9c71c63e15897f687e168dfa91738944"
    sha256 cellar: :any_skip_relocation, sonoma:        "d04e3da63bbb10b1259091eac34566a5a84f143ff808e975a855f58bef74f8b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbec252660c1e1a2c382768416ac5f46849eb31f8a382f4ff9d3f62fb8bfd2fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6787e8b3cff9053f291cc49430e1be029a2171b6e10f67278474a74352068303"
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
