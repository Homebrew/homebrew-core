class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.3.10/pie.phar"
  sha256 "d5e72d69a823c0a955bb60acf6a7ecdc754b90b0a7b73f13f75eaea3503b267d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc35e57ee40039b69dfa8cfd97cc534b26353b6d6d7122257355d2f18eb5ee15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc35e57ee40039b69dfa8cfd97cc534b26353b6d6d7122257355d2f18eb5ee15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc35e57ee40039b69dfa8cfd97cc534b26353b6d6d7122257355d2f18eb5ee15"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ac6df20d1b5456f6101f55d51d6cf01255e382d064f7c3460c4957ccee27b21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ac6df20d1b5456f6101f55d51d6cf01255e382d064f7c3460c4957ccee27b21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ac6df20d1b5456f6101f55d51d6cf01255e382d064f7c3460c4957ccee27b21"
  end

  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
