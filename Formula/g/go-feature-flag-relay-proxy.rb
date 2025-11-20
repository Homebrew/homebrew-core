class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "925b08531375da8e1792f09e1148b6fe24ff911560d5fbb7deb5e8530dfda7e3"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c360f9ac49443a436d9ada635a3dbebf7274f924687d0a00e15e10997183fc64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f69e1457731c1fb17fadaab523da1197c7976c0f15cc78e4ede78a4683822aca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce3b03c3de54d0e51e26955b05ccd85c7b5f0a2eaf8b5eb21684bba8790468da"
    sha256 cellar: :any_skip_relocation, sonoma:        "90c44d2421727d7b62657904954fd79c340afc571bac2ab9a670046f3fc4bf8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b6337938f4831206bae68a9b8a2ff49555e967e4d7b27e072bb9c9848d0cb19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a00946203f8b181401ce2e7deb88d38161d0d980b25b9d27ec407147acc949a8"
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
