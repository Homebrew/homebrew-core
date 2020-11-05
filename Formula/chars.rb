class Chars < Formula
  desc "Command-line tool to display information about unicode characters"
  homepage "https://github.com/antifuchs/chars/"
  url "https://github.com/antifuchs/chars/archive/v0.5.0.tar.gz"
  sha256 "5e2807b32bd75862d8b155fa774db26b649529b62da26a74e817bec5a26e1d7c"
  license "MIT"
  head "https://github.com/antifuchs/chars.git"

  depends_on "rust" => :build

  def install
    cd "chars" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    output = shell_output "#{bin}/chars 1C"
    assert_match /control character/i, output
    assert_match /FS/, output
    assert_match /File Separator/, output
  end
end
