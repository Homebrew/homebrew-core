class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "cfb8f9324aedcadf717dfcaece258e48268c4d907fe1f190b26677b3a8693338"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74aa50af30861857f9f35d784f239e2a78279d2c466d80925b33ded4c281f447"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a676645208f1dcb959f4562d874685a9d86a84b24cee1be2bdd51c92aa19d53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18a73e1ea801b3f74e067f3c309f64a567bbd7bd2f43d7469e64c63d35a50c1a"
    sha256 cellar: :any_skip_relocation, ventura:        "3bf317cf41c7ad548e0aa31d7ae3a9e52f06c0a8ccb3953fe4fdc6342c5e2f76"
    sha256 cellar: :any_skip_relocation, monterey:       "d991590e096351ad990822848b7e434ab5e448d74d356d4c1e08c725dfe069e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "977c8b05898db37a373520f816f90619ed476a1c0423e316acb2cb686dad465c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a44f1213068905223817ea2b8879ba01e3b7b82c46a71e0cc958095d918dd2e6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    random_key = "R4AA2dwX3FrMbyY@My3X&Hsmz7W)LuQy"
    fork do
      exec bin/"livekit-server", "--keys", "test: #{random_key}", "--config-body", "port: #{http_port}"
    end
    sleep 3
    assert_match "OK", shell_output("curl -s http://localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
