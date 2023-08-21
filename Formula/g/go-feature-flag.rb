class GoFeatureFlag < Formula
  desc "Simple, complete, and lightweight feature flag solution"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "96d29dad09aa5fe30cfd1bf87ad44a4e1d0084f7881a2d8bbb4a512ddab4b408"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c291b21ac72e719501bae16be5d1bf5b0f50490d1c01f6bfce4730237263c3e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee33f3857599fdc829751a968a5886319f3fe08b5e5171cdb024d60de660e170"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84227f3499cca6bf9c80ae18e6e26f98cd407e65cb224e45ebde0b845b400795"
    sha256 cellar: :any_skip_relocation, ventura:        "6d88105c4d7d3dec100b4f9fcaf7ea5475544876f075db5e50916240b85e4893"
    sha256 cellar: :any_skip_relocation, monterey:       "9a1a8a1d5d94bf076a07f8196619559bbd666e9890619b25fdea7f14b8311109"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ca11fa77d25f1968ae9bcda24b45635252951bedaf26044ab85ee9477229172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3af54abd59f812b654e5e170b409a28ae1049fa6b56a1975f3cae0e86cba6cc3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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
        exec bin/"go-feature-flag", "--config", "#{testpath}/test.yml"
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
