class Pputil < Formula
  desc "Lists mobile provisioning profiles on macos"
  homepage "https://github.com/juwens/pputil"
  url "https://github.com/juwens/pputil/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "c6488af0c98a9eb9bb7bb928d8ff1b58d8a33cb6207a1b5d62ad32eba9b83525"
  license "MPL-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # it's hard to create a working signed provisioning profile file for test
    # hence we we are limited to basic smoke tests for the time beeing.
    shell_output(bin/"pputil") # only assert exit-code

    assert_match(/pputil [0-9]+[.][0-9]+[.][0-9]+/, shell_output(bin/"pputil --version"))

    help_output = shell_output("#{bin}/pputil --help")
    assert_match(/Usage: pputil/, help_output)
    assert_match(/Commands:/, help_output)
    assert_match(/-d, --dirs/, help_output)
    assert_match(/-h, --help/, help_output)
  end
end
