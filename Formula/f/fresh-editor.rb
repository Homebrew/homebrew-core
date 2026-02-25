class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "3187666a789110f67b90b5cb46f803005a528ef7c514b45c16a5dfa875f96593"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a55cb97c35b38dbf8112408ea4ab084c85f1c0b7dcd89207e7c78fb2656f43d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "016f99d4bc644c90136362a8377e8f9c7e9734595470e6061dd5da482a1cf496"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07c224a2471098deb65aa26e5d6268825ac7369042b7f70633fc62263682737b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccc4e0ecb6157c9e77b91c3a1ce1e7453405697ffe9b508a6fd6e30e802d4e4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc7489a9bf7ca33c341cdd5bbab28f250a6d5e036fb46f40f4fcc920e8e67fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05e194ce89fc50ff2f793739d3760216e46d7907ee8e5f00c6254b001cfcdc23"
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
