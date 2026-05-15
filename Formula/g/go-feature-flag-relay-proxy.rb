class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.52.1.tar.gz"
  sha256 "ed1bbae07f54080a0b1dfff39e1c2b28b387580a0b26bbc3369299bcd73c7afc"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8155536d54eaa9a595c0af4b45f552f64bc7fa80da047a28cd62102e55344833"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3247edac380e318d0fc23ac85aa6ffd91d454e6a7e5914ed21aac30301d33ee4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "280715dd2641d01a6cfee1a12e3fb3a6b6e0cdae2c24f508f75f9be2b68ac350"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b0a02b12448878f7d33ce519622562383a4a5510f2135b3391a0338fe4ff836"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e988b4ab8f92d6b4ac6226e5f054f60dd51a842be6aeddce2a00c4b6889578ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d5d0f7cc1271de572a15410288e6ba5c357b553217b7da1f2e28dba7fbe3fb0"
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
