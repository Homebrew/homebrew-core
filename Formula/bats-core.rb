class BatsCore < Formula
  desc "Bash Automated Testing System"
  homepage "https://github.com/bats-core/bats-core"
  url "https://github.com/bats-core/bats-core/archive/v1.6.0.tar.gz"
  sha256 "a8572da41593d13837df6c93d01fc0867c0701c53a7e29b7a7c867dcce19a239"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6911a873446605176d6cfb219b335f1bd073da5be1834290829b062497443420"
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
