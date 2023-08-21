class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.15.0",
      revision: "403fa03c279bd4b5a19e3741da23ab11e1071490"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08ab557ae812389fed5619cdcafdf4bc7417f9952a4552700f478bd5b7509cb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ab557ae812389fed5619cdcafdf4bc7417f9952a4552700f478bd5b7509cb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08ab557ae812389fed5619cdcafdf4bc7417f9952a4552700f478bd5b7509cb3"
    sha256 cellar: :any_skip_relocation, ventura:        "f2ef50dce47a31834c9c76fc8a870f3c62540ec6659c776105defc2370e66655"
    sha256 cellar: :any_skip_relocation, monterey:       "f2ef50dce47a31834c9c76fc8a870f3c62540ec6659c776105defc2370e66655"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2ef50dce47a31834c9c76fc8a870f3c62540ec6659c776105defc2370e66655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e335ec21946076abd99adeb6453592a6e1af47c59f84e00e2f3b8d28e1d00b13"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

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
