class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.21.0/bashunit"
  sha256 "655f4e4af47d4f0f6c794e4906bc22f16d9e1cfb4e277f5fb3a679322205bc10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1df61ed3a723ee1ac730d3e2c061f22a8d9923ecf99542d94b662a4799a75df5"
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
