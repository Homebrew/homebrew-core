class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.18.0/bashunit"
  sha256 "70dffb79118b9dba8f1a8c83a60fdf79b01b0442c6260dba4e694522bc6637d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c31823359d7c203e280c39c7efe933afc37504d370ff14c141db06d2e23a04e0"
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
