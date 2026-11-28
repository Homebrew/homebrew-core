class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://github.com/Skardyy/mcat/archive/refs/tags/v0.6.9.tar.gz"
  sha256 "e36278e7b23ad443726867f0f5061ba2795dea3d630ccd99e7eef50bacb545f6"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    manifest_sha256 "2b06df397009a23510f86311016e00130043410e23081567195ff725083346f5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "12174fdb382278372106ce861794b5a5b9153835689e2d65ad9cbbb6dfc7b185"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5e3df3cc92ae3852f1b6b5b1aa42dcc1c7361cc5a0986d4566ea467901495dbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8891ad6a81336651d8b298e69a49515f7ac8f08632fac775c6475e921d5c7c27"
    sha256 cellar: :any,                 arm64_linux:       "d64228dd248326ea35542d7aca70e1e1fa9f4def954df7a55aa175752c9ffecf"
    sha256 cellar: :any,                 x86_64_linux:      "03ebbfb3f7f4e6ffbf565cfebacb0eef3507761a3dce2e008141ea48a16b916d"
  end

  depends_on "rust" => :build

  conflicts_with "mtools", because: "both install `mcat` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/core")

    generate_completions_from_executable(bin/"mcat", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcat --version")

    (testpath/"test.md").write <<~MD
      # Hello World

      This is a **test** of _mcat_!
    MD

    output = shell_output("#{bin}/mcat #{testpath}/test.md")
    assert_match "# Hello World\n\nThis is a **test** of _mcat_!", output
  end
end
