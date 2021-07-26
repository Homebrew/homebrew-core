class BatsCore < Formula
  desc "Bash Automated Testing System"
  homepage "https://github.com/bats-core/bats-core"
  url "https://github.com/bats-core/bats-core/archive/v1.4.1.tar.gz"
  sha256 "bff517da043ae24440ec8272039f396c2a7907076ac67693c0f18d4a17c08f7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "757a7ba99f6aec5343c4cae561ad68c56ea3e03e7de8309aa4cb7958392291ff"
  end

  depends_on "coreutils"

  uses_from_macos "bc" => :test

  conflicts_with "bats", because: "both install `bats` executables"

  def install
    system "./install.sh", prefix
    # Replace `/usr/local` references for uniform bottles
    inreplace lib/"bats-core/formatter.bash", "/usr/local", HOMEBREW_PREFIX
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
