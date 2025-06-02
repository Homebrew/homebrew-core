class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.20.0/bashunit"
  sha256 "d1eed647b705ff91a3ce233b06cf300fcaf540a411404e2287d50c66699773a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fdc32c2e50099ff5903284b4ca82eee66e515dfdc4c8f16a02577c6d320b2fe4"
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
