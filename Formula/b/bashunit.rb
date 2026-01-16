class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.32.0/bashunit"
  sha256 "c0609ee93bc60c60e171cd7a95479f1e900df974f559e874acbbc3e7b925d6a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b6d83e0f3827f7358c54b47f2db5715ecec9873a7f621725cd3a978d1510aaaa"
  end

  def install
    bin.install "bashunit"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      function test_addition() {
        local result
        result="$((2 + 2))"

        assert_equals "4" "$result"
      }
    SHELL
    assert "addition", shell_output("#{bin}/bashunit test.sh")

    assert_match version.to_s, shell_output("#{bin}/bashunit --version")
  end
end
