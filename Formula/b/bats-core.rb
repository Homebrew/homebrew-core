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
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b1d947f6f436990be319ec03d9b147c58dd385d1c77c1f541410c1f0aa776fad"
  end

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
