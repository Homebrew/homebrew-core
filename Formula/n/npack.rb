class Npack < Formula
  desc "Use the right package manager (Rust)"
  homepage "https://github.com/zhazhazhu/ni"
  url "https://github.com/zhazhazhu/ni/archive/refs/tags/0.0.8.tar.gz"
  sha256 "2f953a670317860eacf75e3f503e6b6cdc1ed9b1b6638a541006b7af672685e3"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"ni", "completions", "--shell")
  end

  test do
    system "false"
  end
end
