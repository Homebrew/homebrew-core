class BashUnit < Formula
  desc "Bash unit testing enterprise edition framework for professionals"
  homepage "https://github.com/pgrange/bash_unit"
  url "https://github.com/pgrange/bash_unit/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "30aefc0a75196000680f0668b495f3f98c568eb06d9187eab1e9b2e07237802c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5c2b16b7d7957d69eed22673aba747a50356bd15e6ed3fa9e673f52932f8f7ca"
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
