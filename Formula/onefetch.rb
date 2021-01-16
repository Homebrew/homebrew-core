class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.9.1.tar.gz"
  sha256 "33ac8e019e5b7412fec3c7593843e0c3780ca473498c31e36cbe95371fff943b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "06339555df2a9c2ba57c18250ff8a8ce944fef21beb15ac67d3c5401ff7f8639" => :big_sur
    sha256 "7dee0184f7092ce4edc5506ec045e5b86010b7353a67ccf79cf434c0742cbf7c" => :arm64_big_sur
    sha256 "d569f81ef63cf6cd74dc8bd77a67ebcd1bcbb2c887ce307ca63bc7987c5379e0" => :catalina
    sha256 "0a80a5e06ea5e1d65874d1fe3e99d6583764e3ac665b0061494e5322e3563003" => :mojave
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
