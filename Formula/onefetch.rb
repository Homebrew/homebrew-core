class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.5.0.tar.gz"
  sha256 "1f4d34f70fc38d453f875c40852c535a5c5b011563262209976ecaf028a664c6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "27171a15aba067cb38280669e653ab1f0f2e11543dc561d780317129edeeb4c4" => :catalina
    sha256 "266e070dc4d1fdabd9516d03d9d489f6daf901e28aa7a4852e381d1286756be2" => :mojave
    sha256 "7200468a5be454fb189fd21423dd748c9a662f9ae00befa308a17bd176f83229" => :high_sierra
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
