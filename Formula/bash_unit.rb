class BashUnit < Formula
  desc "Bash unit testing enterprise edition framework for professionals"
  homepage "https://github.com/pgrange/bash_unit"
  url "https://github.com/pgrange/bash_unit/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "f5b64e6d59b3f0195291a7299ce12352893043a5d45abbdd031f36aa2ea511a3"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a5932adc304ef19af6b2a3d9bedcfa032cae7e836213af997a77198658317568"
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
