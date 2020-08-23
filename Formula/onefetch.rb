class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.3.0.tar.gz"
  sha256 "6091a0411a4278cd2de9f78d451188440c084ed944a48451adb77bc7d2e0d54f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbf22545cc10205cc42d56d4eeaee2eba3d097f748991dc9be1c4b9175e68af5" => :catalina
    sha256 "fd1bad0deb4bb53ed23b6c2ae5cb526fcb4d9f5c7a78b87e9705e5bd91638c91" => :mojave
    sha256 "0f90ec2c5d5afe79e29883197c2d7465f85e8df002e381312d27533e068be465" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp
    system "git init && echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    assert_match /Language:.*Ruby/, shell_output("#{bin}/onefetch").chomp
  end
end
