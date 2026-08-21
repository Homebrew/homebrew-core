class BatsCore < Formula
  desc "Bash Automated Testing System"
  homepage "https://github.com/bats-core/bats-core"
  url "https://github.com/bats-core/bats-core/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "bb537b70b15b732f6d8827dd6578e3d8ce166636ce1f18ea9a074184fcce9177"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ba6d697b92936bcf8730f783b6c49c13666e2d286ec7e7300d58c0dc35ac502"
  end

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      @test "no arguments prints message and usage instructions" {
        run bats
        [ $status -eq 1 ]
        [ "${lines[0]}" == 'Error: Must specify at least one <test>' ]
        [ "${lines[1]%% *}" == 'Usage:' ]
      }
      @test "skipped test" {
        skip
      }
    SHELL
    assert_equal <<~EOS, shell_output("#{bin}/bats test.sh")
      1..2
      ok 1 no arguments prints message and usage instructions
      ok 2 skipped test # skip
    EOS
  end
end
