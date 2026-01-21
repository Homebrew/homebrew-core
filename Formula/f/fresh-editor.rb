class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.86.tar.gz"
  sha256 "7427c53b34db330eb75b846aa665cbd5f7d7437d892723d46cc94916450a6329"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccdd5c48d0e03c20820c69889012186b510cfc7cbad348e3ea22a1e91a971c84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d124454028e07205f7ee65a870d81d52f2e7fc9b44b02d474ede0b87408de04f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9fbfd447379eef6568cf1e0308ec727aaabb6aded21382f1663c0d0fa44357d"
    sha256 cellar: :any_skip_relocation, sonoma:        "67ddc02fc8cd07bfc2573bc08cfdc4d35db5900539efa8bc3aa759920a389365"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "970121da9ddd167a9586191eaf4bb10e9b549e712a5a57d8f2d071461980646c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b96fb96cbf3ae2b489b813d8ed475f4b3e2d10b33bba87eecd2a8a85cc53ff78"
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
