class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "87cbbf4c0dd25ad1db7f59681319f324b3e1f6b472e41f6c04bab17ebe0ffda3"
  license "GPL-3.0-or-later"

  bottle do
    manifest_sha256 "936a5a0a2dc9ddf0a23565760c14227c52d6f6f75f13785f9b2660c24c4bb3c8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47b58e1078b8e490afd436ca25b92d7df134ed2ac42f2779c894abc7ab549ab4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3ee2f762ecf517c432617eac723e2f62bb4443f9ad128c4137ac6ccb148d6428"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5e10c486dc0a727f3a42f5788ebb15c1971872436fd45ac842c6c5f31d7f2d04"
    sha256 cellar: :any,                 arm64_linux:       "e90d5318fb2893fffea0ca4a1f3192b4d344b807adced9ce4f84fb87a615aca2"
    sha256 cellar: :any,                 x86_64_linux:      "663da1173cd7c6c2b363bbf0d25ea97ddcbb44650f175cd6181a5ee5d19bf88b"
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
