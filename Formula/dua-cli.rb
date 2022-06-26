class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.17.7.tar.gz"
  sha256 "6ef774e96d256bc450da201f6f69b355c88a5dc0aa8d5ef21acda9394bf18482"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2403a6c3046d965a48ade74e2a0c2c136d93dd5fb9c87bfb96370fa85a905a0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f17705b1cbee04c028dba09c946d062164ab04abac15bfada13d7cae77d51c99"
    sha256 cellar: :any_skip_relocation, monterey:       "ec0d41d6859d0ea37ad6271804edca273665c20513e8f055b21d35bc825f443e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b87dae45f5b7ed9a4c19b79f5b6f3ff26fc917307b26e9ff603cd78c95c368da"
    sha256 cellar: :any_skip_relocation, catalina:       "ba0e956c8948811d27753616b977dc0a36ade4eb8d43de35c30ab626319d34f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d60a42249ffcb70cb2017215692b43e377e248130102aac8cbc1013e1ba7754d"
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
