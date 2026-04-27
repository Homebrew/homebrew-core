class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.12.9.tar.gz"
  sha256 "a1b5cf3b0a1c2d9d703dfbd4c255fc26fb903eb800a574d06cb399bd3c4fb90c"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbf11a4249b7c45ef7a2e3095a60fcd50a373f77f521d575cb4a318fc9019d44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "173560df643663299a64c3801220ddc46c9ce9309c2e822a50c2469e4af69935"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "016fa38a48a38610f9c126f0d55973acc7e904d29404c7aa9f842421b9976401"
    sha256 cellar: :any_skip_relocation, sonoma:        "76197dcd97f41e0ad043013a62086b11e8a2d7e0f182813f76da31b1c6181f22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c707341e063e5d826b387b9895f8a8b7c3302f6b360545eb1688aaa9b0a0c53a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e295895c0b05bf93672830deca80f74cb72a3c8cde4f25873cfa37da232ebc7c"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end
