class BatsCore < Formula
  desc "Bash Automated Testing System"
  homepage "https://github.com/bats-core/bats-core"
  url "https://github.com/bats-core/bats-core/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "a85e12b8828271a152b338ca8109aa23493b57950987c8e6dff97ba492772ff3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e117b2e74af3e8a6edf752036fb1622382d7fc8861076cdc49e372cc9f991fb"
  end

  depends_on "coreutils"

  uses_from_macos "bc" => :test

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      @test "addition using bc" {
        result="$(echo 2+2 | bc)"
        [ "$result" -eq 4 ]
      }
    SHELL
    assert_match "addition", shell_output("#{bin}/bats test.sh")
  end
end
