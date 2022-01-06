class BashUnit < Formula
  desc "Bash unit testing enterprise edition framework for professionals"
  homepage "https://github.com/pgrange/bash_unit"
  url "https://github.com/pgrange/bash_unit/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "d55a6b15e4e118157be64654616cac55bcbc24fabd486dcbb61012cc71cf2f8c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "16935ab15f8f0a6913bc253e85a2a8fdc0ea29d61ab90e6dcf86fa62f253afaa"
  end

  uses_from_macos "bc" => :test

  def install
    bin.install "bash_unit"
    man1.install "docs/man/man1/bash_unit.1"
  end

  test do
    (testpath/"test.sh").write <<~EOS
      test_addition() {
        RES="$(echo 2+2 | bc)"
        assert_equals "${RES}" "4"
      }
    EOS
    assert "addition", shell_output("#{bin}/bash_unit test.sh")
  end
end
