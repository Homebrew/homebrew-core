class Precious < Formula
  desc "One code quality tool to rule them all"
  homepage "https://github.com/houseabsolute/precious"
  url "https://github.com/houseabsolute/precious/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "2de1f5ed8d9013065577d51e6ec3762e6cb1db7aff20e0495f312416728e2e07"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/precious.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd6e560afd5e11c758cd3cc323561a3a1e02c1f990f0104a30a5e9deb4c3d295"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef04cc653f7eab5a37320e3ba3e5fcfd5e09853e4fb86108d7f45703a8fac3fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33b70577af36c3374977ed222df01eb4c46594011cac74159d86a98f7d0a36dc"
    sha256 cellar: :any,                 arm64_linux:       "c26c92450445f44739f7764582d8f451b3bc1cb4a2681be9cf49dbb7128569d1"
    sha256 cellar: :any,                 x86_64_linux:      "bdc0bc51fcc1b7cfa3aa72bdbed3e023942bab48e0f26e6fe4028ece23679344"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/precious --version")

    (testpath/"test.rs").write "fn main() {}\n"
    system bin/"precious", "config", "init", "--auto"
    assert_path_exists testpath/"precious.toml"
    assert_match "rustfmt", (testpath/"precious.toml").read
  end
end
