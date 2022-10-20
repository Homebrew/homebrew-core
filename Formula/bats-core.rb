class BatsCore < Formula
  desc "Bash Automated Testing System"
  homepage "https://github.com/bats-core/bats-core"
  url "https://github.com/bats-core/bats-core/archive/v1.8.0.tar.gz"
  sha256 "0d4c44823905af5e52a92f9164595c183fb0d0b43b0c4e9c9acf794af20468b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e9c11ca0383ecccf76065ccf65b0c53ab172ac26d3325a5f067adbe10e7de48a"
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
