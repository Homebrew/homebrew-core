class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.1.0.tar.gz"
  sha256 "54c7b543b39cf22bac2505c792d7fbba75bfdbe1a19900879b439dc65c75c414"

  bottle do
    cellar :any_skip_relocation
    sha256 "b77c8972bc84e19b9be005f8e39501534ee80dad87e8f0d3b510f3772d470c48" => :catalina
    sha256 "e700489820122dd35495bf62bce935f0d3ce7af771f6477dc535b8575973391a" => :mojave
    sha256 "1a46c6c38c0042838d1ab7a696a4c22e104ee2fecf83a4191fe851a8a3eb2856" => :high_sierra
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
