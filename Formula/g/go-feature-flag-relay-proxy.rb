class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "c071c865e5666b2b04fc0e07a9b94a69f74e762efe996d60d538ebcfb147fbc1"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "394e731f0846708efcb17f2e0b1baa45769aa337dc1af874de291e3d97cff4fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "702e8b402584e50d0a608ef496e0e73514decd58d49aacd939b15204c4d814ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c9a6a0ddd3bdc34e982d1ffcf0a481788fb3b48aca354086c86b5545f0d46d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dded6f4c9628da10924023aa03f286b6b189839bad2c667580122cf14ba141b"
    sha256 cellar: :any_skip_relocation, ventura:        "533edadd9a63f21e06cc69e08bfaf981e4ca690a6b80d1f34591e08341d13e01"
    sha256 cellar: :any_skip_relocation, monterey:       "3d1d2f6344db35f64ff42bca5afb71b76b6528da4a720ffa79017ce9cfe42cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecaa50e8e999d061826fe3c5037925d8b1dd7601585439dc0fcef2f09a5192ea"
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
