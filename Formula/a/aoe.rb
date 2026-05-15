class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "c8c62ceff805fcf0ff102e52ad006a1fea925905939ee830071747a134babae2"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5096969bccc7f779a70e72c94530f1323a6ec8cdb772b7fd7c99b61374c416a0"
    sha256 cellar: :any,                 arm64_sequoia: "85e6c4fad3336ef2f2f65c45e48448fc1a88dba4e320e9365dc415314b41bfad"
    sha256 cellar: :any,                 arm64_sonoma:  "94be4d2154c2933955637706ecb622996b3b7f53f2c4b9c16cd0a6cf5500178c"
    sha256 cellar: :any,                 sonoma:        "55bd3184bf440e21c272003dcabb46cd6cdc0cff969022ac41b0ccfe62d1c8c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f62f5400f22cd31f3ff79450c51f3558d79bd31883d804742aa40b8b63d724b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "064c028d62dd3d224b3ea16f4a030f1316ab4dd222191b863c9dfcb17d67349f"
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
