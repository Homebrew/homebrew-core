class LanguagetoolRust < Formula
  desc "LanguageTool API in Rust"
  homepage "https://docs.rs/languagetool-rust"
  url "https://github.com/jeertmans/languagetool-rust/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "d3ed057524712b9efc79fedee2b9e32d3abe2974778fe5e85ac164b17303d5b5"
  license "MIT"
  head "https://github.com/jeertmans/languagetool-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbe7ef6eb53513b1fabb5920481477442c61b2d42abd1de46b41ff68549eeb1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed9cca4345c0e92e3d656e0b56059e56e116ebef82ba75eb447fa9c0dc0862e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a13d2b017fbc70ea842ad99ab13585d1463528bb647c47d543ac1a9a2df98137"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2fc72b2f35e40586056c14924f82916e272ee31633fe2eaefa2a4cda57700c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a59748d2f44ee2c8154b650208ec639146ee81c0727963d8866ab7d4f841b3f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78d67fa2988592f6d8468448a0c5f8b26fa654f981e35efa9b1346092a4b07ce"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "full", *std_cargo_args

    generate_completions_from_executable(bin/"ltrs", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ltrs --version")

    system bin/"ltrs", "ping"
    assert_match "\"name\": \"Arabic\"", shell_output("#{bin}/ltrs languages")

    output = shell_output("#{bin}/ltrs check --text \"Some phrase with a smal mistake\"")
    assert_match "error[MORFOLOGIK_RULE_EN_US]: Possible spelling mistake found", output
  end
end
