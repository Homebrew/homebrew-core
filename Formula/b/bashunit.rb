class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.26.0/bashunit"
  sha256 "7ff253ec2cb665d560fd92d314687f0d6a256f9f9f13c57b3c4747d056e659af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "604f39c434f4d1e5e871844756a9abcaaca391dd5c57883ff252ddf4b5c68a93"
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
