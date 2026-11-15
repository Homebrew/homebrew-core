class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.53.0/bashunit"
  sha256 "21661108a5d7a396c16ffb74af14c43affcc18d7f68cd0fb3d8768559cc2d690"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a148cf32b76ca43de82060970edc752ca54491157c51425f630fc2dc08ba3298"
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
