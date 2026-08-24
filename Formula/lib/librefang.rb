class Librefang < Formula
  desc "Self-hostable operating system for autonomous AI agents"
  homepage "https://librefang.ai"
  url "https://github.com/librefang/librefang/archive/refs/tags/v2026.8.19.tar.gz"
  sha256 "630cd6cce50e19e26254de107ff6478549038fbb2aefddfa0449f99aac00f385"
  license "MIT"
  head "https://github.com/librefang/librefang.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "312893e9369680e3e3e2b0c5ca61923b4a707eb52e2181041467322840e5ca7d"
    sha256 cellar: :any, arm64_sequoia: "fa7fc894c6c66e78a94b3bbeeb9d4028eef66ec8bf7376b3d625353d215c0cee"
    sha256 cellar: :any, arm64_sonoma:  "09f9f368f136989c137b38728ffba201702f6ad46bcf8418dbd02435d94b8838"
    sha256 cellar: :any, sonoma:        "fd1face71c6cccec526cc2ee41020e0ecbbe634b4bc857eb44fbd4c5f17640fa"
    sha256 cellar: :any, arm64_linux:   "837493c253f113cce11aa0eb112957d32d0e28fd447d400e72266ce35fe1ceff"
    sha256 cellar: :any, x86_64_linux:  "a87fa0f3890b55a938da1d35c3cad052451c9138539e48300bef48ed57124e14"
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
