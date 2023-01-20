class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/2.15.1.tar.gz"
  sha256 "53b1c3acff1e557d3ff9f9a5f6ebbc1a6a5748912a6b96cb6ae0e35e9b5954a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fca68d469c926ba18adad64bf58bcd36c472d16fb9d4bd783a75ba94eea3d6be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a930e2a2cbbc39fcff71c78b23a79a9340c193badc6869db561ec8e13e06b27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e70df35cf69626137408b1c26d624f5fe1cb2fdfdb3c1f5d6459afc603d73fac"
    sha256 cellar: :any_skip_relocation, ventura:        "1ec8aad1b80654586ff20a5945db7e69c28dd26b3b211967f9fad26c2cb66e8f"
    sha256 cellar: :any_skip_relocation, monterey:       "cdc1ea5eaefc948a8b37672a01cc83dbd6a55224bc040948ad8a1ca49df85c9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f5ddddfa77c2aa077eb808cd0e0610d755bc95a4ad87634dcfe11f9b7c4d09e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e371157da5efe3c3752f85689e8c78dd74d3f2456889bf6ac8e1bdf9470a2571"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "docs/onefetch.1"
    generate_completions_from_executable(bin/"onefetch", "--generate")
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    assert_match("Ruby (100.0 %)", shell_output("#{bin}/onefetch").chomp)
  end
end
