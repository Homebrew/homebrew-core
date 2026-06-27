class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "25f97f4871bfde690118019e324518067b1e34c5746110b50b0d81c9f4b89acb"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52969753178add086ef5c37df92fd7eb2e7a8fd8a91902723b151fd413868e5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a9cf21bb648bb2857117636238f83ae9e56768d1724d8a318b8f9e827fa4155"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e138bcd56d3eed9b7bfd1b28764502c275639da18954067bd26b46be726cedce"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b9a482f708d92048b9470a340a52336761f86aea603a4074da7f77f2878fa0c"
    sha256 cellar: :any,                 arm64_linux:   "44fabd8b9360453ff666c55861da420e35f35681233831b9b854ead7c143100e"
    sha256 cellar: :any,                 x86_64_linux:  "3972acd1ef8ed70033604477ad8455306b54a93194657d0d0a9eefcd96b5d2a8"
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
