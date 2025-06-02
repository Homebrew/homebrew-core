class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "01f03d918770f513d25984e5794471ee0fd3dfb40259d12377b599a02958a09c"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "861697391d9830d2141118c09ef589e413e9d18f9fb4673708feabff3e5d46b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aeedee413d79604a023dada924f7a0d8626aad5195532b6cdb821a87992bc44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "645c3e8bcf37f6dce83019df43ad28b8c06871d8a07da54c5232c73eb5c12f80"
    sha256 cellar: :any_skip_relocation, sonoma:        "973be5b40776281d281119d9767bd9ba8a011f81be2276b98b9e968374d687fc"
    sha256 cellar: :any_skip_relocation, ventura:       "8ccea8fb63a085aac2f20dac7b93dc88fd9d755e796dd8d889f52fcd939923d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e68e3a0db209ef6a4b7bacd7ecb2ca9eb19b5f2e9bb248be6b34e35fd119965"
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
