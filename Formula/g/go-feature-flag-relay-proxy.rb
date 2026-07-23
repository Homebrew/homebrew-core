class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.55.1.tar.gz"
  sha256 "66ade20b42758adf827b7723866da5850263488bced283bf451a1d28cecbcdde"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e834903b469eda689759dd930ae34799cd3c724a212e029cef48f18f3d027ba1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e948cc9bebb5eefc6285c51a22a30fa001cf18691c8646ef9640c1b9b76f24ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56644e3bb1ad6a08b9893f383d4d8002b5ecb3508dc999c3f3d7c79e31905b3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b23bbe8ee9ab9a9d7242ae7683c1fc475799695ffdd5a17d08e429e7fae22b10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cd2b13d3d0df377680b64eb2efe32961874bd2b1ea3507ff057fb6cae809d00"
    sha256 cellar: :any,                 x86_64_linux:  "a812c8a595cf30c868344bd9d6b98529ceebc1cb79fc2e707b0bcff5404c3058"
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
