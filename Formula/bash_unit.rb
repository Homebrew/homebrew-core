class BashUnit < Formula
  desc "Bash unit testing enterprise edition framework for professionals"
  homepage "https://github.com/pgrange/bash_unit"
  url "https://github.com/pgrange/bash_unit/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "fe6543b49297dd10db8804f22b75c985e4c29d3ea6c60dd12d2aeb197c45e0d0"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4a81ca0cb8db0163c26fc2de9970baa8f9d5332436a60033ca2db865364b53cd"
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
