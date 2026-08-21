class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.50.0/bashunit"
  sha256 "1df4d6358292fa972e3870cc6ad5946c06b3fdf162aa796fa108dc1641465b14"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dd4dac42cff8b893e1f5e9fe2bef29b11d2ad25c107180cc22d988670f50832b"
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
