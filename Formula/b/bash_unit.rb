class BashUnit < Formula
  desc "Bash unit testing enterprise edition framework for professionals"
  homepage "https://github.com/bash-unit/bash_unit"
  url "https://github.com/bash-unit/bash_unit/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "a2f76ddca88e2bef7c628c8cac6bf68b93a388fce143f6a4dc770fe1b3584307"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c7b39455fab02fd97f73960e4c41b3d65f7695d5442d3950385c4d5fe874f09"
  end

  uses_from_macos "bc" => :test

  def install
    bin.install "bash_unit"
    man1.install "docs/man/man1/bash_unit.1"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      test_addition() {
        RES="$(echo 2+2 | bc)"
        assert_equals "${RES}" "4"
      }
    SHELL
    assert "addition", shell_output("#{bin}/bash_unit test.sh")
  end
end
