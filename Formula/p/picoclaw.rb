class Picoclaw < Formula
  desc "Ultra-efficient personal AI assistant in Go"
  homepage "https://picoclaw.io/"
  url "https://github.com/sipeed/picoclaw/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "05e06f9db2a7900f37519108f55957a41374e72e9ab2440fb787e923b0a303fd"
  license "MIT"
  head "https://github.com/sipeed/picoclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90ae35f29a5e630654c3de923adc83648a94e9bdf5ba71b57e186a60cb44764d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90ae35f29a5e630654c3de923adc83648a94e9bdf5ba71b57e186a60cb44764d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90ae35f29a5e630654c3de923adc83648a94e9bdf5ba71b57e186a60cb44764d"
    sha256 cellar: :any_skip_relocation, sonoma:        "78d284e459d90a406a3cecbf1792a7c752a2bb04d78d75d487d38b9dc597d71b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33681f98cf40dbb18e79e07be4c90c35512a4ca99a8acf39fca8c52b796ae4e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62e9bac2db3019f6be891505f510b2c7f7878f07feb5a8aece320cecfe4bc53d"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./cmd/picoclaw/internal/onboard"

    ldflags = "-s -w -X github.com/sipeed/picoclaw/pkg/config.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/picoclaw"
  end

  service do
    run [opt_bin/"picoclaw", "gateway"]
    keep_alive true
  end

  test do
    ENV["HOME"] = testpath
    assert_match version.to_s, shell_output("#{bin}/picoclaw version")

    system bin/"picoclaw", "onboard"
    assert_path_exists testpath/".picoclaw/config.json"
    assert_path_exists testpath/".picoclaw/workspace/AGENTS.md"

    assert_match "picoclaw Status", shell_output("#{bin}/picoclaw status")
  end
end
