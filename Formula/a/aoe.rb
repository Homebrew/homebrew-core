class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "012019e7dd668624ec471d9990fd3c0a89009782d1f5535c6b63208093e2236c"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cb4e5312a140d7520f25a135067b58016cfb43b453239ade1006faa600cc5455"
    sha256 cellar: :any,                 arm64_sequoia: "8c1e35edd3ecf84831177a3c3be8a1b34cd7de2210b25b3c33428c124e50e043"
    sha256 cellar: :any,                 arm64_sonoma:  "c76c6f349df59f1ce646c34cdac36734f18cdbec0ba9dbf14dd546a92124e75b"
    sha256 cellar: :any,                 sonoma:        "b7eabb34894b33d76911b65fe6742e0257ce860a0884555a304a67c9e539c698"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18bbacc195dca1416149d2403a46039e121b1c6e37c8b3672b03d81936a7d6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a705059d6b2a1f39cc8f7558b3d0e71a9309126b54cf31f43d74ce38ff5765d"
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
    generate_completions_from_executable(bin/"aoe", "completion")
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
