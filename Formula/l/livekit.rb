class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "dd507856dc00832350be7cb07a3731c02d62da0e75d44d34fcfcc35f79333198"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f5e4eef8a548eabf90e0a922a3ccc2362baf2254e7b560fdf387a8cda251852"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b9733a8b19770835dbe4a097b2f3dc7990fad886b664b25f841802cafcfe42d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f86c74dba5617a4ee3c5f3fb8301f12b964acd2f1bbe8cec909c05ef243eabc6"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4143a3dd05c664e93e7f92b7bdf6dfdbd80e74666b9cdff570138e39fc9cf16"
    sha256 cellar: :any_skip_relocation, ventura:        "c3b8175bf239cef562535e5e382339b1cc5992a527bd9103331351d239be9487"
    sha256 cellar: :any_skip_relocation, monterey:       "751daf464b9fad66b84ad534a576a2a22edd74f534229e014ba4fa1b74584fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a09a8f8d1b111da2d9eef41906477fb2ca51d6514f1c0aca544de8578f4f61a"
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
