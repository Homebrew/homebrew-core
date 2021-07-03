class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.10.2.tar.gz"
  sha256 "6e4d4effcd4fd94ce21625a5e32da5da6446c8874200e40dd791e623b7aff7bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b34a0c5e5b96f6f4a9d291987768f92052ea180daaac3eb618b6dfff7619062"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b177010dd910134a1e3bde7e6c3949a6be21fc09f27e5c69e4d97972eef2d31"
    sha256 cellar: :any_skip_relocation, catalina:      "2766a40c10e0e4a0dcca6045964698238a8497cb3120b8679fe488cacd0934e4"
    sha256 cellar: :any_skip_relocation, mojave:        "0830e9a9e0b6e20b6b0f48fab6600fce1de884d6a7b5d3b29c8c5aa4fabe24a7"
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
