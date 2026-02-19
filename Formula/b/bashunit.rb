class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.33.0/bashunit"
  sha256 "e81c5c262d2e7296598b823c7d7fda1b54a818f5324cee1d65cc3b074a194ed0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "221a172df70ee5c01c94f0e2ac83e15fa4e6bff3835011c3f9e199039c88c981"
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
