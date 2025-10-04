class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.32.tar.gz"
  sha256 "ecb2380cfdb3e6bdd38c576855baa906763ab2554c6bb3c11933fd6e1472b19a"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8f7b60365c463fa1261295482855c3016bfc39310ca1f09f4a4738935049bfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "772667f4f1dccdbe00d8a5eef3d7ee7a0a2b0c684aa43bb12e72b77a0483392d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93a58feac13a2f017cfb8527d848d2c621ed2abbb4ca11768929af53958dd83e"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb818ead181ffbc3e5f6714f52fd7bba5f3e70e8c06ffe5367f0240ccc35ce3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab382a5acba9b9a12d0f7ad1ea396efe0928ff6240c73f06c4f884e0fd162a1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8eebd5c4d69a9415f8e39350f991cca02e024f9af8a58f12a1b02555877a38b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nanobot-ai/nanobot/pkg/version.Tag=v#{version}
      -X github.com/nanobot-ai/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanobot --version")

    pid = spawn bin/"nanobot", "run"
    sleep 1
    assert_path_exists testpath/"nanobot.db"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
