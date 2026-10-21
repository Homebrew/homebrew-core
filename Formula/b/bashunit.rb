class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.52.0/bashunit"
  sha256 "6193370a2164abcc1e64601af461ea811505c6cefdc8fa33e579a07e2d05ffe3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a31f520ac32513a0448d1e4890016d964f338bce8f1edfc2066bec3db037e8dc"
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
