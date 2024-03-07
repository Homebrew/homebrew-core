class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "da887c3e7e563691c8475a91d3c879658098efef625a029a7119f268918fe103"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1fc57ea821d8058b92ab3a37eb1f9b6a898a412fc90d8c5a409f30107c074e06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09f721108516296b05592a3a49117671f3943ce84e2d8fd43bbbde8b4d537433"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04159c1e24a41beb1d91f73e37e58f0c6e655df3e695f10ce0f67e5b6bc00b3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3cdb803d4d9848a97f4da5b437261f6105018b390648dd564062845f65c7d362"
    sha256 cellar: :any_skip_relocation, ventura:        "d90dd084ee0f5dca7cbd5a88f845a96fe350d527170fd194c28f1d4015011d8b"
    sha256 cellar: :any_skip_relocation, monterey:       "025e6672efbd3a6823ae36857ebf09e2135a0b03a10287550ec28c769cd60eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f444428391dd5f802c0602ea9e624a9864117b8d5f923b87ff34ef96a47f3dd4"
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
      sleep 3

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
