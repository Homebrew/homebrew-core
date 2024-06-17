class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "1079b4ce143c0fc84a70ab805d02a77ec9d9dbb929b7f4c23b0aa9abc6a44067"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e06ce39ef165205abfbf352b92377df05515bf79c702139f63b76d4d8b87f10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56348ad3dad763e807999fd1287bdb3d2eb620efc025af183a6e3793f98bdf78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10dfdb9d5893cef86661360721aa39372e12513429b07657a064444fc545c876"
    sha256 cellar: :any_skip_relocation, sonoma:         "17139fa7895d999b6ac8ba4cd5fd1ae01ea60ee7e8e59e97ddaa2bbc9fa5fc55"
    sha256 cellar: :any_skip_relocation, ventura:        "1582decf20a19d9936fe640dc55fcaa93f77e257edbf9747d3640c3d104751c7"
    sha256 cellar: :any_skip_relocation, monterey:       "cd29ba49c8b077cdb66630f8ac4427ebf545801c16b98ff7235f43c9a0bf17b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc0cb0f4d38843a1f7014b2bc209ed85088528ea1921c144abcc69ffd930fc71"
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
