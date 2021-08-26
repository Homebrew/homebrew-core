class DroneCli < Formula
  desc "Command-line client for the Drone continuous integration server"
  homepage "https://drone.io"
  url "https://github.com/drone/drone-cli.git",
      tag:      "v1.3.3",
      revision: "15de3807233f20528b85206cc73160337c10447e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ab4ec9be822052d568f98fe6b0c3d5bac5a1aed12099d888041bb01f3ef54741"
    sha256 cellar: :any_skip_relocation, big_sur:       "bcfb5688ba6966c7d12d838db3e4d1e934e6540f16d14db3e3396b1da6dcdfe0"
    sha256 cellar: :any_skip_relocation, catalina:      "d4a31d58bf3bf5f2faab6761c8d3a29bc33334403570ff79f41e371b9b730c99"
    sha256 cellar: :any_skip_relocation, mojave:        "e174e0f30436a58cf2e1502ae2bfa0d4764bab07ca15a46f9259aa5a18684c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d43bb381afc1bccf0776f25c003fb505d72a46da7429af5a8cdb0f8a6e74ea3"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o",
           bin/"drone", "drone/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match "manage logs", shell_output("#{bin}/drone log 2>&1")
  end
end
