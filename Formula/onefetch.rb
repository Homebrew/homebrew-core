class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.8.0.tar.gz"
  sha256 "0be1a4a779ee01a72d104ef854163d67a5cbb5b988816046f5cfbee8bd08834d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "07c62d13046813adf43ec8376ce1abcc9fafb2ff8f81e0c0ac2dcbac44318319" => :big_sur
    sha256 "0d3a78ed3865cf967746b8e696beed1c290ba456fd6a8314346334f723a254ad" => :catalina
    sha256 "250e3decffc886853d99200fb428c3a7bb8bd08d9ad10f9c4eb222102933f7df" => :mojave
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
