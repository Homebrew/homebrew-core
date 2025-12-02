class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.28.0/bashunit"
  sha256 "31cbc589a0938e33cd5eacd8028afbb681601b40696af5989e7a788dab208b79"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "818ad797f143dd973c21360ca282b1d4b5923b917bf775e0e8bfcf7b4536df7e"
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
