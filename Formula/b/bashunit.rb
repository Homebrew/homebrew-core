class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.8.0/bashunit"
  sha256 "0216d2c1e49ce0dd8303d01c076d24a5cb3fd54fd94634216887c6edbaf4a2f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "415c601e63ba36c9c8523e5c204e92743ab4c4976acad5d4e3779b42034f2cc9"
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
