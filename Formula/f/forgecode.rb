class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.21.tar.gz"
  sha256 "882bf104a727160dcc747ff2da6b789c9006595d13084549c72cb49d228bccd6"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8b96e6a6c6f7447a61fc65651d4bf40dd886f8675e1ffa8eb2c0271a6f0e2fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01f78e32798e3f2bd8e78718d441cbf0e2fd7955ccd0a34f790640b4df556bd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ba19cf58cb54f4ad3136ea5d3f9462cfd12374192c9b1e6d4bcd5abb71cfded"
    sha256 cellar: :any_skip_relocation, sonoma:        "618c552a0bc1665d665ca761c37c1bdeea3e1f1c4afd3bccb23a570231c206ff"
    sha256 cellar: :any,                 arm64_linux:   "69063658687a3fd8250c83d431c608d49919becaf0a3db541747d0279a2baa75"
    sha256 cellar: :any,                 x86_64_linux:  "151cca330d5d591aec69b71f03ef749174b8b25c22128342e26baaa5eba628a8"
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
