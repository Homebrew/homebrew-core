class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.7.1.tar.gz"
  sha256 "ac2129ecc0ac1bf5ee9bf8a6511f3cfe9b53c873860745346c060ecc8f902848"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b3e02f4eedb99eda8a752a935899baee21e972b2f7aade64aef2331b46b6644" => :catalina
    sha256 "160b0e9f86b386dce6c8236938465727c0e6cfcd6690527934787df81cbe67cb" => :mojave
    sha256 "1dabb0f229e28a98c494bd137f2f8b970f2390d54a5a21fcbc2965d1bc4989aa" => :high_sierra
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
