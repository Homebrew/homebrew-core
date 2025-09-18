class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.24.0/bashunit"
  sha256 "db65b663556ea1290879f09c653f9ff0e32372e41a4cdc1eb339a294a4095a02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6e89795511f40c43471578bfdaed846149b7f5662401ba12cae40839c4ee1119"
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
