class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.51.0/bashunit"
  sha256 "307e3a84d5561d1a1d8b5d378184bb1dfda3e7a7856c4a9435d63a53853cf72c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "acacff485249fa8106edccc2bec67ae527e5002bb0adedf9834461a298232179"
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
