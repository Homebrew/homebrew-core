class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "a61a98a2057729ead79183f39357f8bb034cbd3f919342d4395247aa79a4025c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "475f4c4d1599ae2f24f29a139263cf45cf92a6629ebc46faaf409a048795c8ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65f17d3c7ba31254f952078fc9986694a3cc90751ddb40497b3ea6077be3989d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89ac35fd697ba67b103c31960d0f62e161684b41ed6968414a84cdbe5cf599b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "94247dc3f938bb200a6f5539a6ccac5be0ef5d06853ee4cad270453b4e16f2ab"
    sha256 cellar: :any,                 arm64_linux:   "7fe9d48951d63a76a30aae491e296f8411534eff5642f189e3b8bfd7cfb1c7b8"
    sha256 cellar: :any,                 x86_64_linux:  "54dae0967718aa9143d59a6d997296cd36dc165a51b3eec4da9e6f9a210f90f2"
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
