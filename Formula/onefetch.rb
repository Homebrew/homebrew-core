class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.9.1.tar.gz"
  sha256 "33ac8e019e5b7412fec3c7593843e0c3780ca473498c31e36cbe95371fff943b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "460853143bb40faf7de7d49c64616d4eeea29b0de22e9c153f31af3f7c1605db" => :big_sur
    sha256 "0a11932b3795555ff253f46390d64d6926c9603883929c8b5dcc07ed5dfd7f9e" => :arm64_big_sur
    sha256 "0e9069d562ca1b387472e961493b8cc6f962bfa81d8de3cc86f06bc40bcd4d85" => :catalina
    sha256 "1a6342771b768a51b042f1978b360a374cec75ac4ed2a9dd7317db6aff552127" => :mojave
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    assert_match /Language:.*Ruby/, shell_output("#{bin}/onefetch").chomp
  end
end
