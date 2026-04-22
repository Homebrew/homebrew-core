class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable"
  url "https://github.com/anycable/anycable/archive/refs/tags/v1.6.12.tar.gz"
  sha256 "c6d63143de21970c10ced2ef2d4b70eca8bfbef7d398419adbd05695ef478fc6"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e954c4e618512aa9c78010a32ce7d40526fe274eae8c0df5c28429d8192b36c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e954c4e618512aa9c78010a32ce7d40526fe274eae8c0df5c28429d8192b36c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e954c4e618512aa9c78010a32ce7d40526fe274eae8c0df5c28429d8192b36c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ed4d2b742b9601c39a22c56ecd1cc96cbc47663e01f5af26b0b6ba3671140b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52dbfc38b601245c7a85b7070af0b8f9dcaa241ac67bf2f8e286a2067b71dbba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45e94a5e316d515df89e3c6b92659e77c9db671d89ae6dcaf163c33274000129"
  end

  depends_on "go" => :build

  def install
    ldflags = %w[
      -s -w
    ]
    ldflags << if build.head?
      "-X github.com/anycable/anycable/utils.sha=#{version.commit}"
    else
      "-X github.com/anycable/anycable/utils.version=#{version}"
    end

    system "go", "build", *std_go_args(ldflags:), "./cmd/anycable-go"
  end

  test do
    port = free_port
    pid = spawn bin/"anycable-go", "--port=#{port}"
    sleep 1
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
