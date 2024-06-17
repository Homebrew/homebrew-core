class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.12.0/bashunit"
  sha256 "c968376996fd78d346171c585e1d3f7fcc62b7b8e2b9c4f472072ee72da04683"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0786a8fffa284461deb7fc21fbaf599469b58167ace1cb2898a5202bb4e81a71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0786a8fffa284461deb7fc21fbaf599469b58167ace1cb2898a5202bb4e81a71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0786a8fffa284461deb7fc21fbaf599469b58167ace1cb2898a5202bb4e81a71"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee88008c50f8f4e795fb48c2b03bbcb3ad86a7dfd39c0a43e2f0824d705d7f16"
    sha256 cellar: :any_skip_relocation, ventura:        "ee88008c50f8f4e795fb48c2b03bbcb3ad86a7dfd39c0a43e2f0824d705d7f16"
    sha256 cellar: :any_skip_relocation, monterey:       "ee88008c50f8f4e795fb48c2b03bbcb3ad86a7dfd39c0a43e2f0824d705d7f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0786a8fffa284461deb7fc21fbaf599469b58167ace1cb2898a5202bb4e81a71"
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
