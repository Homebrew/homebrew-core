class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.12.0.tar.gz"
  sha256 "f57b16dfa2bb95dd1fb805257a1761baa20d69eb9ce7c311d369609894c53897"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14329e52884db110cee66f01adcb3b8eacb727ee89168babc58048bb5a5a5d01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff6d677011879fe9cd3b8b6dfb6b69bc0e6ff2ab7de8273ced602e243530841e"
    sha256 cellar: :any_skip_relocation, monterey:       "506ac362844e2abacbd75b5b863309419e2a03eea42c201dd6faed1b8624b4e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "eeeb2f6e74a243573259be8a8342bac4a6c638063dd2364980423f1fa10f04a8"
    sha256 cellar: :any_skip_relocation, catalina:       "88c955974088f0ee61033b21b2e8bfb7950964a4993ec8aa1cd0140787db67dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "370515a1bae2b42bfd0a92d9f9d8ca7127dd752ce0bc936c1aaac20a1cbe71da"
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
    assert_match("Ruby (100.0 %)", shell_output("#{bin}/onefetch").chomp)
  end
end
