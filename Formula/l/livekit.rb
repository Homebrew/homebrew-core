class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "f3126403e6408c9a7ca49778b5a8af78dc27623c3f9430cbb81fd79ced006429"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c01309445c956805ef664b66fa9d58ca9dacaefd435643a80c52e793354f1ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "724c31f4099cf67182b67dbb67e16ec1c86b42de5bce4a0960a402a6eaa4934d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faaced6611c0924b98a3aafa6f63fef4942a9456a07b79a83ec93231cfdd56e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "883b4756bbff42c5f00f0f5edc808beaa183acd2dc0f9d245b7e552e5f4e450b"
    sha256 cellar: :any_skip_relocation, ventura:        "c074a4f5c76dbe03f7884d9f49b9c8669670cc85ac7fd1d5c7367a391683c7b5"
    sha256 cellar: :any_skip_relocation, monterey:       "73cf14e0066e2d43772cedfcf67fde2739cebaad1a87d6a7c49afdc2b720b5c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cfc3853f76a7fca8097fbf661f6d90a063f5927a44ecd1aea5bb822666613d1"
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
