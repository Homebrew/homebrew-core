class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.10.1.tar.gz"
  sha256 "c78b69a230125968df9defb5dfd04fa93fd9c91bcec6ebf02f4b5b50ae5e4360"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0a11932b3795555ff253f46390d64d6926c9603883929c8b5dcc07ed5dfd7f9e"
    sha256 cellar: :any_skip_relocation, big_sur:       "460853143bb40faf7de7d49c64616d4eeea29b0de22e9c153f31af3f7c1605db"
    sha256 cellar: :any_skip_relocation, catalina:      "0e9069d562ca1b387472e961493b8cc6f962bfa81d8de3cc86f06bc40bcd4d85"
    sha256 cellar: :any_skip_relocation, mojave:        "1a6342771b768a51b042f1978b360a374cec75ac4ed2a9dd7317db6aff552127"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    assert_match(/Language:.*Ruby/, shell_output("#{bin}/onefetch").chomp)
  end
end
