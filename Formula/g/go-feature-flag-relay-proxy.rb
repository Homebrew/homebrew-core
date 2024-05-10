class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "2b3c24f0ad10f8d826c446631a40300021ec6b140cdaa9f6488cab700a6ba273"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fa13f58a05e23b35833d51ec01932717fd31fa32fd2171a1b5c504d327c311b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49ad4987667b7b303446d95e13918263fd9fa4a482d89c4eefd11f87a7f57569"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4d478aa896b9a18d14a00862388c8e232b421db85c65e1155afc3a09ccc8e92"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c4cca394070221c7513f7b08cd9f0a0c6b93ce06034bfe544256bafa7d234f5"
    sha256 cellar: :any_skip_relocation, ventura:        "c077c13ba8eafce83fa62728d3204ab3a23b57da31039ed61b95fd017d507c35"
    sha256 cellar: :any_skip_relocation, monterey:       "1dffb35e5ad449956b9bdaa95bebb3f6cfd1fc64d73a9a5816c9e7ab1a6f859b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "434c3471819794d9c3a35b7a03fbf3bf5cae3c47bc233bc788ed12f124943d25"
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
