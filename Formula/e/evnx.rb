class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://github.com/urwithajit9/evnx/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "25911ada6375169aef59a6356685dd528609e44895ef295c6b134b3697aa9c72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a05c44863c7b6b5a3f657a5d48d8252ce20159e9b67c81f27413796cb2636d01"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "398d13538a32125b0a3cd6ca1384c4f6da5d2dbf59af6c5b1a36214ae59068ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab628fde890eac5de8c1959e7babfb50b8940223668fcd66bec0ddd43b7793f9"
    sha256 cellar: :any,                 arm64_linux:       "f32c6b5f1fb2f6433f73e44bb1094278baf943c52f2119185465b9a4867e5fe5"
    sha256 cellar: :any,                 x86_64_linux:      "fc998a7c69950d10604534fc3aa7387a7173e4641165edd931094270f0de2773"
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
