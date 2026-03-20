class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "623bef2ed51e70f432979fbe459296b2bed6b1247493fa07c94d2078c405bfbb"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bcf84b34a331e431cfede3b80ef365b47a0aa1144d35e36cf695ecac7895bca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d888d76a6be00c46503f9c2bc70cf5d7baa6fac6636798ea3251b4c21cb125c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b658a56a2169efe96d7e3a2f050a1413d9e88101912c5361876b97015ac4bfa0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffefb6c739bd41ede09f8897f28b84ec9b1a46835d71765708a3d1f3f7b4208d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddea071945b4db081d69166fe92cdd289a0af7828fe6789018c3756a6c0a646d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b016e0d6c8f08b5e6a12509c965f394796aacea3a248b9690987561bce96d76c"
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
