class Bork < Formula
  desc "Bash-Operated Reconciling Kludge"
  homepage "https://github.com/mattly/bork"
  url "https://github.com/mattly/bork/archive/v0.11.1.tar.gz"
  sha256 "4dabfca259cc529a19597c6f748f1492985ee2f6d7ac88cf70fa621b99f7a927"
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
