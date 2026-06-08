class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.38.0/bashunit"
  sha256 "b1364d4874e61bc8cee4d9dea15844badebdbcc855d4d5b5439c9f4ae8b2204c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0eeb19997a75cfab6411cd7ceb1b5f34ca90ce4c06eff9560f89ba46fa790bd3"
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
