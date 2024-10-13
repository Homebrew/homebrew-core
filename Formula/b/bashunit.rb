class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.17.0/bashunit"
  sha256 "f8d49a52ae5a89e86024feb21214693db31511a9eb391aad22dd2645aebd82f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "792700ae931cee00ef72bcbe04f5260fca1dbd5826cb5928f80360c6bf7c7333"
  end

  def install
    bin.install "bashunit"
  end

  test do
    (testpath/"test.sh").write <<~EOS
      function test_addition() {
        local result
        result="$((2 + 2))"

        assert_equals "4" "$result"
      }
    EOS
    assert "addition", shell_output("#{bin}/bashunit test.sh")

    assert_match version.to_s, shell_output("#{bin}/bashunit --version")
  end
end
