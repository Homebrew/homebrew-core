class IntelliShell < Formula
  desc "Like IntelliSense, but for shells"
  homepage "https://lasantosr.github.io/intelli-shell/"
  url "https://github.com/lasantosr/intelli-shell/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "de3846628332a19740f372f9e6cd3ce84d1d079de75dbbdfa1e92715a08d0f9a"
  license "Apache-2.0"
  head "https://github.com/lasantosr/intelli-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "88374861d3d0c47640d805d76968f578aa65b19c5587608b34e0ec36db242c61"
    sha256 cellar: :any, arm64_sequoia: "d523d7de4149f9312578a3e09bdc5178c4d06ceb15cd01b4f3ff18acb1a60931"
    sha256 cellar: :any, arm64_sonoma:  "7c0c02e34c5f46749cf362452eb7de4dec8397b10dd58af751dcbbe06c501572"
    sha256 cellar: :any, sonoma:        "6a948965fd995aaf064d1a0a2024ca3e2294f6f9f3bb7d9f97d31558891e82f9"
    sha256 cellar: :any, arm64_linux:   "f7494b2486d25220707ff8b56ad6be32aa666b488314e4dcf79e79988a2f2f78"
    sha256 cellar: :any, x86_64_linux:  "31e8cf8e18ebbb3ad87a123fe7bf4675ca4db9b776fb19ecbb887e039be150eb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/intelli-shell --version")

    system bin/"intelli-shell", "config", "--path"

    output = shell_output("#{bin}/intelli-shell export 2>&1", 1)
    assert_match "[Error] No commands or completions to export", output
  end
end
