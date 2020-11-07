class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.7.0.tar.gz"
  sha256 "7d9f060c2b9fd683006373ea6fb1368c147e0b84edebc261bf4468bfdd3f7358"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "11655cd5654644a3cadc0406c474225bf449d8658952f4227f35e0c8be47cfe4" => :catalina
    sha256 "3f141349341475e10008d77b1008bda6690ea7575cfbc2d0a89cf0fa46049008" => :mojave
    sha256 "dc1c69a73e53fff8afe79e990c8b088c8ae63dfdb5c53dbf9e90fd2b21ae266a" => :high_sierra
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
