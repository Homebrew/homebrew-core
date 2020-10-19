class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.5.0.tar.gz"
  sha256 "1f4d34f70fc38d453f875c40852c535a5c5b011563262209976ecaf028a664c6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c248e34afdde7ce7756a07f8adcfac526d94bdb3378daf85d44defda60cc041" => :catalina
    sha256 "ddbe1f6ca29ffe3789c390142ff92799d39b58fce8b20be5c751a37d312960e5" => :mojave
    sha256 "869230c06e81e477ba6a9b1be1b770f49431e62297183f63ec3c497bae546301" => :high_sierra
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
