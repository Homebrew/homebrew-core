class IntelliShell < Formula
  desc "Like IntelliSense, but for shells"
  homepage "https://lasantosr.github.io/intelli-shell/"
  url "https://github.com/lasantosr/intelli-shell/archive/refs/tags/v3.4.8.tar.gz"
  sha256 "b51b7b92c7f7cb7a418bb91f49479a1c388e336d0405298633c4fb7e1edbb9b0"
  license "Apache-2.0"
  head "https://github.com/lasantosr/intelli-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "908f21784ced610bcd316f874e510f9f2ff5766042d5b1280e89a6bdc5229eed"
    sha256 cellar: :any, arm64_tahoe:       "64d06975303a8ae01735e34b1fbcc914d9d0e51fb476b8bd1e60ab69f632ee4d"
    sha256 cellar: :any, arm64_sequoia:     "5aadd4ac79ccd1d0bc2c565e11c3b06e639806e75b10e212483d6b1bc6bc71c4"
    sha256 cellar: :any, arm64_linux:       "91ef5e27da122aff8f74bfe60ff57e9b1dc26adc0121e514f16c03e3f9f5ef75"
    sha256 cellar: :any, x86_64_linux:      "2780874160d5a64b9de89be709050343206df6273c2f459328715b6a478f9e7d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
