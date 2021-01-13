class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.9.0.tar.gz"
  sha256 "55d8757b0d41b1ce2ac1e7c1b9960c5542675f6e5234158df029b967e5100e2a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "07c62d13046813adf43ec8376ce1abcc9fafb2ff8f81e0c0ac2dcbac44318319" => :big_sur
    sha256 "14bec354bd1904734e6f2abe59a0d63f65890faee50d63853f07175fea7eaca3" => :arm64_big_sur
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
