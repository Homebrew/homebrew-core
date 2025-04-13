class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.43.1.tar.gz"
  sha256 "733831f3bcfbf1088616e5609b38014b606e50f6517753cecb3daaec439981e0"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "217de85b9c1542f59642423da8747de95527e864c902e2e234f698236b843be4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6a9ebb6ae01f06c53d0a785b5c3d4e0978a84cfc85d385f0bcb30d979b78ff4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "362a0215d8041cf7201e29f9e39d6f995fbc1209f3337313d49dff362eee0de1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d93ec8bceac795ab093412283f53fbc559e1ca0a8815d7c43ed5a5af536cf6b5"
    sha256 cellar: :any_skip_relocation, ventura:       "d853f80be07db56fbf910bf5ef24545ac996c60173cef5ccd6391829c2677bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29441239d0780a7658f1218f818e8ed459574920b16c430ffd854f60461346f9"
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
