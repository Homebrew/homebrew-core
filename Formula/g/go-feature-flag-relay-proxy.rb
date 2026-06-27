class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.54.1.tar.gz"
  sha256 "22a4bede011726ed80a3d5420b59353e228b01fea4f990281ec4f96c072350fd"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "452255e658dab29d1920cb176d254c5fcb287cb30b520e48ec3a44738a017bda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f0eac665902073721c790c6b590bd434bf8af299656aa0714aa33db832a4230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e318f5ea2ed81390fa6ce29d0c7bdff03aa707850dfbbf089304e913a46012af"
    sha256 cellar: :any_skip_relocation, sonoma:        "8127d39ef2593171ec7ba110f32bace73f403e4746d7d65b4736df667a902e36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6312a85917f6c34b406fe1b3e3efe7e4577201f3e6eef8d7a34081f60099077e"
    sha256 cellar: :any,                 x86_64_linux:  "0b46eed2f53ad247a812cdf57b4dd85fe3a55435be07ccea98ef5a7b3a0f25e4"
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
