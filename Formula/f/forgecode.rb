class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.6.tar.gz"
  sha256 "76b2e8bd7180a31ae6375953c19ee1ec5bc2999597a719d1a5b5d5fa7df1fd6c"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db29c611a0b6d01bba199af643f5daaa25a3ca7e58d48b6590f3d3e18f740040"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "962245a1273a6e89af3ac40b4ceb18b601cf1b1c0eb10f693d6d3c0207a98911"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1f2de959d401e841be5eb806a335fafcb9d2cdee066d08278d4e4c345dab0cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ff6e689f157ef99a2d578a9198fac7544c4d671aeaed413c4be73393b397107"
    sha256 cellar: :any,                 arm64_linux:   "4b10ecfeb90585d8f32989882c5235a7dfaafb94c3d098c3a177c4777242b3a8"
    sha256 cellar: :any,                 x86_64_linux:  "8111c4fce9e6924ffe683d50e350c39823cd4a875597d6f4b42b4924b1566049"
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
