class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://github.com/urwithajit9/evnx/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "51ea8c32699cc2eda5b5f7cc81e1e47a5d64a0287d9c443fdf695ad0ed267a9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "676bd4ab798ec3325aa1f3d0f6244929b7afd7161e5a14ec810a55363fb17c25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f2dc47a20237901b8bc62dbefccacf224e45e43aa78f2d69bf2338714364e45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "408d1d746633ddb98317336ca3e292c60364c7a40b20d863b6144d99d52e4b42"
    sha256 cellar: :any,                 arm64_linux:       "41bca98f2900ccd587f2dcb7c935437046c8b5f8f26d65c23547ec0af2086119"
    sha256 cellar: :any,                 x86_64_linux:      "d97fd7e31281a96b5933dfe0821d21f218e5afb52537a1cdb805344c7f5eb76b"
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
    assert_match version.to_s, shell_output("#{bin}/evnx --version")

    system bin/"evnx", "init", "--yes"
    assert_path_exists testpath/".env"
    assert_match "All checks passed", shell_output("#{bin}/evnx validate")

    (testpath/".env.example").append_lines "API_KEY="
    assert_match "Validation failed", shell_output("#{bin}/evnx validate 2>&1", 1)
  end
end
