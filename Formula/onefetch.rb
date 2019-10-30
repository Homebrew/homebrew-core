class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v1.7.0.tar.gz"
  sha256 "b0fd4862a1f2847688ce9739eba7a28b732e6fb966086987f4276edd88aac362"

  bottle do
    cellar :any_skip_relocation
    sha256 "1bdd5434c6cbeb43d7f9927fb7ddba72c03232118acb9935242dd8514d69fafc" => :catalina
    sha256 "bbddf3be60ab0e9c0954012f24b086512a5d02acde847f3988c0760dc2684a50" => :mojave
    sha256 "0aec962a9ad70ddbafe38a797e8f24b6f49ee7e945cdd95df91346773281dc74" => :high_sierra
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
