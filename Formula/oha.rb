class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "96b4101bbfd65453d2bd44dea10d99b2553508fff9f5552673bf76c08d8c15f8"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57a4a28659eac04151087e0b8f9ef32dd76d7a7fa3b5742ac3f5385fa48eaeb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4dd3d09328fd92ae234cf25cb0a26e537a6cdf88c59ba2382d0e4ebc98d6f5cd"
    sha256 cellar: :any_skip_relocation, monterey:       "d3a3a661db004f1bc5a0887d6adc6e864b8187242ea544045567d185574c01ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0f45564406275d7edd6e25b794cb10c06a6ff5d26f4842237455df2bf8ed9aa"
    sha256 cellar: :any_skip_relocation, catalina:       "83d863516ee02e981bb60a31202d93871bca69a67f4190f86e44a2bc59e40f18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "875570714b58569467f202f6f032f0bb38ce79c09c09a5d120cd04de1ecd4b72"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
