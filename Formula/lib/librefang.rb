class Librefang < Formula
  desc "Self-hostable operating system for autonomous AI agents"
  homepage "https://librefang.ai"
  url "https://github.com/librefang/librefang/archive/refs/tags/v2026.9.14.tar.gz"
  sha256 "20bf429a30aeeb59b9412b5bc7e01ff35fd51e32803c6d8b4f9cdd53b8fe2049"
  license "MIT"
  head "https://github.com/librefang/librefang.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2a33883fa1f47eadc8319508114e607cabcaff3cc66fea981b7579eec9d24a15"
    sha256 cellar: :any, arm64_tahoe:       "eb97fcb6e58421eb783513f5ae0e6d91be38da51865330f7996767de1bbb2940"
    sha256 cellar: :any, arm64_sequoia:     "bcb37174cf8a0310412ef7a0c5817db3574ac6c9336be53d059183698a9005ea"
    sha256 cellar: :any, arm64_linux:       "d06251baca4a474b2c58dc6e574454894e824054e60c551c97fcfc679459fef2"
    sha256 cellar: :any, x86_64_linux:      "d5aa7ee21b8e78b8056372c8c7d41683e13fa02553fa277d1d2541278eb801f3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/librefang-cli")
  end

  test do
    system bin/"librefang", "init", "--quick"
    assert_path_exists testpath/".librefang/config.toml"
  end
end
