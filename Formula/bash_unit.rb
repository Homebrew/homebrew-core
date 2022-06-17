class BashUnit < Formula
  desc "Bash unit testing enterprise edition framework for professionals"
  homepage "https://github.com/pgrange/bash_unit"
  url "https://github.com/pgrange/bash_unit/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "4a7c243ad0ba25c448f1a678921aa4c94b316c26cbf474e011b133c3386343b4"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "172450ac23326f95aff9d3b7a9685743dbe45f112f3cd7b799f933d6b8f946ed"
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
