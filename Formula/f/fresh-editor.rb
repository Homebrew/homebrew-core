class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "b048bfa38b9b50a262f19ac49d254a1479926ddb74d496367649892ac8720495"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "111b06cb91aa83eef867ce0d198315f82786be050662377416fd1671836f0f7f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21efebb5f52644986bc32f0b55fdb8c05e04f9e613ab3179fa8b3e83aa83e941"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b3f55b2a1ac64063c8c9b1b6c3aef005aa826c0bffb55b53dd7402746a70981"
    sha256 cellar: :any,                 arm64_linux:       "e2cf4f42a9be935e64c3d0c4347c3e41cb04a046f2c0c7834ae530c0f63a2e84"
    sha256 cellar: :any,                 x86_64_linux:      "784048e7a52865fe16a039951bc3d1d0daf20cf416cca50f6a55a79c20aa891e"
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
