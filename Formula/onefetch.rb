class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.1.0.tar.gz"
  sha256 "54c7b543b39cf22bac2505c792d7fbba75bfdbe1a19900879b439dc65c75c414"

  bottle do
    cellar :any_skip_relocation
    sha256 "24b7e0e08d574596b3ecf58979250cf86929c7441a90595b4df889035409440a" => :catalina
    sha256 "74b26c65cadc88c84016d41ab1b656082a5bab933d9fee970e0e4975ed44306c" => :mojave
    sha256 "d2b3cd46a46949c0e23dedc44bace6f1532c45b1eb241c27610f55395d131060" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp
    system "git init && echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    assert_match /Language:.*Ruby/, shell_output("#{bin}/onefetch").chomp
  end
end
