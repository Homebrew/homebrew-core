class IntelliShell < Formula
  desc "Like IntelliSense, but for shells"
  homepage "https://lasantosr.github.io/intelli-shell/"
  url "https://github.com/lasantosr/intelli-shell/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "e2b3fcdda6fa0564f47fb3dc5ce06729f0dc9532e538bb847dad1e684f545e4b"
  license "Apache-2.0"
  head "https://github.com/lasantosr/intelli-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ffd9d2a13c48bbfec521698a7883fa794f108011af1ffb0c665dd4613b3b84d6"
    sha256 cellar: :any,                 arm64_sequoia: "783083d7c75d572d49060cf91498826d7255b14022500ed41d777191a943514a"
    sha256 cellar: :any,                 arm64_sonoma:  "7786822f5c6fdec78def58e16d340d7144cb186cd8d5069352ac2210d481c6c8"
    sha256 cellar: :any,                 sonoma:        "c4a65c06321e443053116a370ca8564e661d8c5e9773477c2761fe11824fe950"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "595861721ec054f8a3476b4bed7f422927ed673e58bbd79029c20106ce0820c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eacef2a0159919efcfc2793a02d91d6718fd6d6bc4238074896a22f72da8b258"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/intelli-shell --version")

    system bin/"intelli-shell", "config", "--path"

    output = shell_output("#{bin}/intelli-shell export 2>&1", 1)
    assert_match "[Error] No commands or completions to export", output
  end
end
