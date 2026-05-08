class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "d137a2db03a377c4f7af5c7cd29befff905d416f0240a5026b1ed3b20bdc49ce"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b656490777a60794382e6d463dd7141885c4a49a7f6a18e00611147d2ec9962b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8633a0cb7babeaf31b189afcff8020a6832a41d3b6a4b08c32091fcaf43d697a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78c783bd5e13d2ba55bf396e60fceff79ebb5178a35c24424a776cef9e02307f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d04e6e4e0a748bb8bd345e276205fe7904d9632e515dc2a2d786c668272d14b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d31e4b4244f1d841b49c852144603268839e66d70dedfecf47d46914e680ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2027579c938f63524f1998afdc641c80e394395c04da138615c5be4e5e36c5ef"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
