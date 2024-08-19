class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "cc3a9fa4ced091f61058846c77305b8d0bb32fb211c475bc37cab74dc8ce7a59"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32f24b35785ce3792d4c68bb66767aeac265b606a223fb8cdf3376af98bbc06f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ae75c145d14893ba48be88a40db577bd3b2453d13964ad561dca02b94ea6859"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8429ac096c1e380c280f69b677f1ed2d40a774aa71ee6510da1a1e769d937a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c62aef33a4f64c5d0d61eaf00619aaa634fdaf956213cfd8b8b6f50767aa8891"
    sha256 cellar: :any_skip_relocation, ventura:        "6c2f8dc080d5dd9ba8fd011d527e2618d97b4f500bf5258a39092e14563fd0fa"
    sha256 cellar: :any_skip_relocation, monterey:       "c80f9604430b8aca271b925e88e8a44cf4150283c385058f13ba911add06616c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eed405f7a9c8d33664a89f7199c8db3260aabc5529ca0ec56ea3f2291484b7b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/relayproxy"
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
      sleep 10

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
