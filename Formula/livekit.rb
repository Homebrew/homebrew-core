class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "9bab9437de09b9565d20c56e8fb3348da5ffe587dd5789129cb6865e4f753ebb"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3fa68946c71c30b41a7b8355c1ca78bed66e7178dd81db4bbff2bb59a1ff3c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5072f9e224d756b9ab29a83eed335f3f55dafa10b6b857d3a14266f88dfcc77c"
    sha256 cellar: :any_skip_relocation, monterey:       "52110e6b3bbc3f3080cad318bf08212b4eb4d328f8bfedfd99a0141a6e5670f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad472483bc0e533c1ec8e8fd8fc98cc3c8088d527c3b62e331b48912f8bfa2f6"
    sha256 cellar: :any_skip_relocation, catalina:       "7ccf5d98d3bcf3f064460aa235aa26903bb47a36696c638246c5fb6b722b3464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0960e5f013cda923389d3545954487269106ab13622d5cc9d28c21e634fa8eac"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    fork do
      exec bin/"livekit-server", "--keys", "test: key", "--config-body", "port: #{http_port}"
    end
    sleep 3
    assert_match "OK", shell_output("curl localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
