class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.14.4.tar.gz"
  sha256 "d4687f547cdd41bc1fe5976b6c6db7ae856bd9106d8fd8bf2d6b8c601cd82393"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c11d5d399dc126c63e6426fac371ad8827239c8175c3cfafabd2163916a2b26"
    sha256 cellar: :any_skip_relocation, big_sur:       "534b963e7375412a38983b1c538a36a889ba49d21676b9ea6df1dafacfe935e7"
    sha256 cellar: :any_skip_relocation, catalina:      "7ecccdd3e7b349a5e9517e0241f2f3b8e45cf8a182fa200ba27ee5eba6ac62ba"
    sha256 cellar: :any_skip_relocation, mojave:        "bd92bc20c29722b0e893bb11cd9762f76651c30d390bf7a2f0de3fb399b840d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "947f6adb98290a6b92df3f6b92dca8863b376d0523c30633f0558aa4bc781d1a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    # The "-EOS" is needed instead of "~EOS" in order to keep
    # the expected indentation at the start of each line.
    expected = <<-EOS
      0  B #{testpath}/empty.txt
      2  B #{testpath}/file.txt
      2  B total
    EOS

    assert_equal expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
