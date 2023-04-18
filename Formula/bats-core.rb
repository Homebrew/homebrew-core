class BatsCore < Formula
  desc "Bash Automated Testing System"
  homepage "https://github.com/bats-core/bats-core"
  url "https://github.com/bats-core/bats-core/archive/v1.9.0.tar.gz"
  sha256 "3c64295318d157616ca2478de819371e2c579ccdab30c1f0b7279f7b214fb1f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71fce4432c97bf46f4ae681afbf2958175b25bb6297a1b11ee10d553d6eddc93"
  end

  depends_on "coreutils"

  uses_from_macos "bc" => :test

  conflicts_with "bats", because: "both install `bats` executables"

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"test.sh").write <<~EOS
      @test "addition using bc" {
        result="$(echo 2+2 | bc)"
        [ "$result" -eq 4 ]
      }
    EOS
    assert_match "addition", shell_output("#{bin}/bats test.sh")
  end
end
