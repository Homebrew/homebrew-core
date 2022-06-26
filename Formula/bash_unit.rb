class BashUnit < Formula
  desc "Bash unit testing enterprise edition framework for professionals"
  homepage "https://github.com/pgrange/bash_unit"
  url "https://github.com/pgrange/bash_unit/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "4a7c243ad0ba25c448f1a678921aa4c94b316c26cbf474e011b133c3386343b4"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec4841bdcc9027a5f01635b81ae15308012af99a4dc8313df95ff019fe266424"
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
