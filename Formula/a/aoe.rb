class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "c7897824b863d3c626a8f09c8e142bd85e6c8d8bca80ec598efdd1d5031cbc2f"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "85cc733e183731bca4ed019d3edef8ea0fa03e9fff3bf478c951d434959870f6"
    sha256 cellar: :any,                 arm64_sequoia: "e4f80121b80e5e21240f661c10a6a183f4fb1fb1935b8a9af86661c474ed598c"
    sha256 cellar: :any,                 arm64_sonoma:  "53cc9c9842c5e353e1f5f68e948c60295ead8162a9b848eb1b7cad8b2c26729d"
    sha256 cellar: :any,                 sonoma:        "95f8898d6b2dff71fed937e448412867a21f2812c9f530762e83d3c7caac16f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e758a2fc02067ddc172ba6c41177c9b9a4cba316eed7b2892b1853cc1ccfa3bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfa1bf7a4f24851d505213abffa8f8d8b93dc56261819959f04e31af47c573e0"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "serve")
    generate_completions_from_executable(bin/"aoe", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]

    port = free_port
    pid = fork do
      exec bin/"aoe", "serve", "--port", port.to_s, "--no-auth"
    end
    sleep 2
    assert_match "Agent of Empires", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
