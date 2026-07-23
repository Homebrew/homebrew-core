class Librefang < Formula
  desc "Self-hostable operating system for autonomous AI agents"
  homepage "https://librefang.ai"
  url "https://github.com/librefang/librefang/archive/refs/tags/v2026.7.21.tar.gz"
  sha256 "2a8633a5d23b72af11338adbbd88d8e5a7593422e537a1b20b895c0cc8a18168"
  license "MIT"
  head "https://github.com/librefang/librefang.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d52dc9663bdc9a349c3f13a6ac2463e54358df38078d73518ff034b5922a1e44"
    sha256 cellar: :any, arm64_sequoia: "b806e4c5bfeae505c9aa3a1ef31d96b45bd1d53ecd94f9d564171620c1ca1ff9"
    sha256 cellar: :any, arm64_sonoma:  "abbd2930d00a657308244a377efbb775835eeb99a64e1bb2d16fde745530f297"
    sha256 cellar: :any, sonoma:        "5a7fb43f4f2e0a9ead0e1148f47b6c9951d7a45ae38b6fedbf42b1a31bad5e5f"
    sha256 cellar: :any, arm64_linux:   "532ac389ee2aa40ab9cf3ab6bde617f76e00444c9fddb7879c24934317303d2f"
    sha256 cellar: :any, x86_64_linux:  "7446ff9a11e9ccead476098f53000c85a09cd56002a30597bfdac262e14929eb"
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
