class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.35.0/bashunit"
  sha256 "bfe9f69bda77034234a38f26182cc34e1f7648d846dab57a513a14cf91977544"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "29b947f9ba433f3be8399362e7bfc768633ddcaf2135b22dfd673e8ef020b77f"
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
