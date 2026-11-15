class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "4069a3db5bd21f24e7c215715aaa63c4fe55d6a317fe001cf3ba703053a227cb"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a0fd4a540cf9b89f0ae43a574f157d795b13828684f81e8342fd6cd92b18cae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fb472083d0d6e97b036eec38b7b716a68d36234fc8d5eb39fc8572e639758478"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d774c5768c47a43c9aad19798bcf259ac7d55df06b902a9a359da599e94cedb8"
    sha256 cellar: :any,                 arm64_linux:       "e360410ecf154983b00a18a97a7730201462f4eb52df1ff2dcb0e1019a2359a5"
    sha256 cellar: :any,                 x86_64_linux:      "8c08ce0d2c682b5f177b48ea219f4452609e6f962751ac1f9549c2cb8cf9d414"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end
