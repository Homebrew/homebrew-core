class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "3472273fcf77b019922b32ddffad061cc068bfb260344865c239c8eb056d92bf"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9bcbb0d055f2379d8d207175997be18e8df36cebea3a863a9acfdb0f6e7d939e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0d5a539ae28b998a9661e29dbc8835f70cff09d28c478722b394103f973de32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "66d7819f9f857bd1565591e2570688ad794659d52fbf651b76fcda6af7e9071e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "cedb9066518bb3a63db5f1988ba99ba85efb72559b515ab909f05c056917b53f"
    sha256 cellar: :any,                 arm64_linux:       "44b253c1f4734d48fad673ad6f1016d0d5d981108891f1cbe5029626544d3b70"
    sha256 cellar: :any,                 x86_64_linux:      "6fdfecd7c2182c77c758c76dfe94cf6dc704aaa515223d5465ae8da212f83a75"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
