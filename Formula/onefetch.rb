class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.7.2.tar.gz"
  sha256 "158126b087805d653ffdc9cceb7afcf6ff053e4285c7be5bc4be5a7bfe636524"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a128d6c69bbdf45527b7831b8f2bbd3da01aac885568100a42eac0ece1876fd" => :big_sur
    sha256 "89abea778eedc4f1eaf6fd6e470dd33dfb5c783065086e26055df047da187acd" => :catalina
    sha256 "984119bd82140f66accea4d58794080ed9bb0bf56704da2c8187e45e288cd785" => :mojave
    sha256 "62fab402b370f85fe536c49739b32b9d4c19d7edeaa6fe7f9417485492f63892" => :high_sierra
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
