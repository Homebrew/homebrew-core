class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.50.1/bashunit"
  sha256 "18d83d590c5304f1853dd4fe4fec4ec6effbd9fe5a21831fe9f66f70afe17d93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b585270b14d962d1e7a65eb0b66c80bcc7513a476e5d4895b1e73c695c5a20eb"
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
