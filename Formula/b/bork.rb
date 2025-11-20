class Bork < Formula
  desc "Bash-Operated Reconciling Kludge"
  homepage "https://bork.sh/"
  url "https://github.com/borksh/bork/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "718331c54c94bf7eddeff089227c0f57093361f7e6e24066cb544cc9ebd2f6c5"
  license "Apache-2.0"
  head "https://github.com/borksh/bork.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "16ffe8fc8e92fb6b7a8563cf610e9ebef39bb4123b8c092087aba936df7ed44b"
  end

  def install
    man1.install "docs/bork.1"
    prefix.install %w[bin lib test types]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bork version")

    expected_output = "checking: directory #{testpath}/foo\r" \
                      "missing: directory #{testpath}/foo           \n" \
                      "verifying install: directory #{testpath}/foo\n" \
                      "* success\n"
    assert_match expected_output, shell_output("#{bin}/bork do ok directory #{testpath}/foo", 1)
  end
end
