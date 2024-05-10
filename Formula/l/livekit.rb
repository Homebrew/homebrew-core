class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "67ed93e45001c56a0c65a4303d2f284c4e35a03a818dc4cff589793552bdcb5f"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "460c1be8bac036be0cb67346d6581e97ec8a741760f24c1239eff82936824008"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55005b7f4787f073242081bc6b6590e6868fe3ad44452939a735dabd6d9c7d07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08907a3c25c4c74075225dbb65fbaaab33685db565bbeb11fee5438d53f99214"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e35fa3689b096c35e5d2eaba13938ee4851d310c90ca77bf966855134a53bd3"
    sha256 cellar: :any_skip_relocation, ventura:        "367dae7d177f65f73d15292239935e88320d5d50b54266e21e86a8187e0e9212"
    sha256 cellar: :any_skip_relocation, monterey:       "8e2003aba43c09749b518d009ec6637d5040093e10713ae8304b1e0044e28435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c71076eb2e61f530e6e57cd914646dae03953add467a386a5dc74c38e8a82a40"
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
