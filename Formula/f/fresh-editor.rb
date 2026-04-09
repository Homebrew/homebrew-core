class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.22.tar.gz"
  sha256 "0e4b7ea378cd8665bf94d2da021eeb983f25af34971236e2ec7a97d3884fa8ac"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb311669a1cf5e0d94dc323c58efd51cbbba57548bc1e5fe35ba9cc311ec10d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b04e23437dfa768a581eb6b5b19d99507176fba809432cebb77f0730dcf90dc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fabfa344b60ebc373325da7716d25bd8da9c6c3e862dde60ea6ce0dbd97d112"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eeb7aa26555602eb06147cc24b417c23ee0f25ee49a9746126a2e87ac2bff2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13527540806c783ffde9b1ddb4eb6c83815a0a6c92c2b289918e465040a414cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65912f7820a6237c81ce31f7e842c0470adb00ccb1908c89c6442a6a45339bad"
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
