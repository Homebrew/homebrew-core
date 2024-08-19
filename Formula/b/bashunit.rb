class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.14.0/bashunit"
  sha256 "84822a2f2d3a84646abad5fe26e6d49a952c6e5ea08e3752443d583346cc4d56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c1cd9ea8bd47d5520162c447e793b0920f17088611493f14a0a1b2a63c6c35a"
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
