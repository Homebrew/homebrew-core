class Colortools < Formula
  desc "List of shell scripts to print system colors and true colors."
  homepage "https://github.com/pvinis/colortools"
  url "https://github.com/pvinis/colortools/releases/download/v0.0.1/colortools-0.0.1.zip"
  sha256 "733f68ebbf942b8ee875f212804a416941962c8845e1cec5127056bd7d31a237"

  def install
    bin.install Dir["./*"]
  end

  test do
    assert_match "TRUECOLOR", shell_output("#{bin}/ct-true")
  end
end
