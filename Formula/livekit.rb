class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "56da723907287d8cf93d39f70c2ca0de7f70d74658eb8d2d6fe0c56ae54e30fd"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d07a7bdd00c717c6d856b91b6907da1b06e7bedadbf5e24de60c665fb2f7cfe9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe71c0697f7e2e23578ed92fbb9c5d3ccbb3b5ac9864ff4d735321db549c6fc2"
    sha256 cellar: :any_skip_relocation, monterey:       "c505a7098102c5dae9919b3958e2d1d49bdbf6246b0a64ee068cea1ec123caf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7645cf2212d9263a7116eb1723b134425e6d373335a2725273ba629469bf82f2"
    sha256 cellar: :any_skip_relocation, catalina:       "97c2a42c290ccf98ccf483dcea688e370f5e5ff001a7b598999b22fccb5c833c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbe95efef643af5bfd0170d8f96e2f8f04e328129754b308959f2305f8d18385"
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
