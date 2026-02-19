class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "10283bc6d8b526b6f05a8b6caf0a514add284ec16589312cc5b0aeb24413872b"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "381be3e55e986e06c1ed07af8e9c5796df915a9588db0eea238a21c01d11abb6"
    sha256 cellar: :any,                 arm64_sequoia: "d5ec41ccb89316d03c8abea1b40ed3af01ae251af775762659a5234d677455e0"
    sha256 cellar: :any,                 arm64_sonoma:  "9ad8e92a3343a011f57ea0ddaab0cc0f613b85a91b7001f1c3a497a59c7fd184"
    sha256 cellar: :any,                 sonoma:        "858b7de8799a91d9010a18b3bad17540dcb649863434acd7df1d65e6e07cd29a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce117393e18ed7a06ffd826c8de53163bd173bf62bbce76e8f866c5b4f5729bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ba711a0552ae15d9263feee05d4cd0176235b1d422effe94e855a95aceac044"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".aoe/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]
  end
end
