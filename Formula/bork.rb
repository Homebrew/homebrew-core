class Bork < Formula
  desc "Bash DSL for config management"
  homepage "https://github.com/mattly/bork"
  url "https://github.com/mattly/bork/archive/0.11.0.tar.gz"
  sha256 "4d254f74fbf13846eff0a9d6ee1dc8d4b0df93faad46d847791fb7b7a56b62ab"

  head "https://github.com/mattly/bork.git"
  bottle :unneeded

  def install
    prefix.install %w[bin docs lib test types]
  end

  test do
    expected_output = "checking: directory #{testpath}/foo\r" \
                      "missing: directory #{testpath}/foo \n" \
                      "verifying : directory #{testpath}/foo\n" \
                      "* success\n"
    assert_match expected_output, shell_output("#{bin}/bork do ok directory #{testpath}/foo", 1)
  end
end
