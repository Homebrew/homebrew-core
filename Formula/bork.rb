class Bork < Formula
  desc "Bash DSL for config management"
  homepage "https://github.com/mattly/bork"
  url "https://github.com/mattly/bork/archive/v0.11.0.tar.gz"
  sha256 "5c9f445962a9b8a8faf7cbdec9599945630b1a21f0fa244ec9d536c5e6fc867a"

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
