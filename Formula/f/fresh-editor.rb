class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "3ab409970e18e692ed7a046bc0c27f4a68119858928e4b4b499e992dc7a0a118"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b892a1fdab5c7b56f13c838b2886c5def3769a6ec251881d9163dcd5f8667ea0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67e013d492522ae01861006d7465eb272c152e6fefab9b7659b7d8d75f8e91fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31e43d6e158d31c8253c452d171206321585671044dd189e3356ddc65fa1d309"
    sha256 cellar: :any,                 arm64_linux:       "4ab4f5c4e9bd61f6844a9abe2037ee0709b009e9000a7d948aae3bf871fcdd53"
    sha256 cellar: :any,                 x86_64_linux:      "4ea2e39f6559c3fb25a8232d384b4e82bbf3febca62fcb201389b62a79f24d32"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
