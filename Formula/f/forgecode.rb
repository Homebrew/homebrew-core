class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.12.8.tar.gz"
  sha256 "f2d66b1ad65a15ca0113f56b003f3e88d4d1e634ef2cce437df900c5c68da5f0"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80f80aa7a8f411989bf87f38f56e9aae8524f61f2a9090f600113b08f26c3043"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c6d81b663b8c38151183c0ebedec67ba3c95ac071a76132a8ab77dec938ac2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8df537c533913ca9b291fc8cf8e985888cd70e244100112f43be577be6b84fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a01bc431611cf566defc42f553797f61b3cdc12cc19f3501603c63fd1dbf30e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ae3175ddca3a2b945ea4f7fbe2f5403ef91e0b9e2e69c387368337cfdc74873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97e372858e522d0a4499383a77d7f10f1e3f3c6129adc967bce202042888ab9f"
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
