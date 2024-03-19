class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.11.0/bashunit"
  sha256 "f047bc9688b9933635e9f813df919485deee3d60be78d96708e08928bc46ce58"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4370c2c0383e64467bf2bbd71cb0380c45170bd209a29230d3d7370b4f9e9e04"
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
