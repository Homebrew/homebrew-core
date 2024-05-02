class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "5671b6e3985aaa0e02792bf9f1d2ba04466694ec4cf3f73e1b9c52379ca16786"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24727fe945eb9322526daf0b42073754a8812dfe7e1518e7152b8723fc501d19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1ba39503cbf6428800c9d02f65b1a167958393cd669124769973513c18ec6d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "645244e8afbc3b7ffdfccc4a1b2e777605345a5464f8f7caf1f610e761d7b8b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7e323d3bf67abbb48fa5672543cbc1aff83ae6993c5329a5d01b919f77be0b3"
    sha256 cellar: :any_skip_relocation, ventura:        "15333f5d40296da74a95b8ce607dae83cbee165dad1009464c67eaf2aa9d9800"
    sha256 cellar: :any_skip_relocation, monterey:       "468dfa826bb62d04fbbcf43262c0f5938e62c999de8ffadffe722c7f33d0e383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5ec94b1ff6ee0d5f7e7199e5ea696c1d0b7c88f821f783943e73e090fd843ae"
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
