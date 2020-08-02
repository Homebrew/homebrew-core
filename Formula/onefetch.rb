class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.3.0.tar.gz"
  sha256 "6091a0411a4278cd2de9f78d451188440c084ed944a48451adb77bc7d2e0d54f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "54ce778668b9953a5c683ba12045998a2a4ae1291a0a2f0e5c4a51aba63e7bc3" => :catalina
    sha256 "4937b9ddd81bf626dd5b5a0b6ec2d289c74ef125a0e5bb0c87641e343d687412" => :mojave
    sha256 "eca2bbb2a918e3ffdf41de1e3703941397265c618a31793a29fba4a37f887427" => :high_sierra
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
